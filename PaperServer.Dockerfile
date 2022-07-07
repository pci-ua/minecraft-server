FROM eclipse-temurin:18-jdk

# -- Update the base OS
RUN apt-get update
RUN apt-get full-upgrade -y

# -- Install ImageMagick and Git
RUN apt-get install git imagemagick -y
COPY ./magick.sh /usr/bin/magick
RUN chmod +x /usr/bin/magick

# -- Create and switch to the new user
RUN groupadd -g 1001 minecraft && useradd -u 1000 -m -r -g minecraft minecraft
USER minecraft
RUN mkdir -p /home/minecraft/server

# -- Compile PaperMC
WORKDIR /home/minecraft

# A user email and name are required to build PaperMC from source, for some reason
RUN git config --global user.email "buildbot@example.com" && git config --global user.name "BuildBot"

# Clone, decompile, patch, recompile
RUN git clone https://github.com/PaperMC/Paper.git paper
WORKDIR /home/minecraft/paper
RUN ./gradlew applyPatches
RUN ./gradlew createReobfBundlerJar
RUN mv build/libs/paper-* ../server/paper.jar

WORKDIR /home/minecraft/server
COPY --chown=minecraft:minecraft ./start.sh /home/minecraft/server/start.sh
RUN chmod +x /home/minecraft/server/paper.jar /home/minecraft/server/start.sh

# -- Create empty config files, so Docker can stop complaining when mounting them from the host
RUN touch bukkit.yml commands.yml help.yml paper.yml permissions.yml server.properties

# Minecraft EULA
RUN echo 'eula=true' > ./eula.txt
RUN echo 'By using this Docker image, you agree to the terms of the Minecraft EULA available at https://account.mojang.com/documents/minecraft_eula'

CMD [ "bash", "/home/minecraft/server/start.sh" ]
