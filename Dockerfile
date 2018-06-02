FROM haskell:8

RUN stack upgrade       # assuming 1.7.1
RUN echo "export PATH=$PATH:$HOME/.local/bin" >> /root/.bashrc

RUN apt-get update && apt-get install -y netbase make xz-utils

COPY . /app

RUN cd /app && stack build

VOLUME "/app"

ENTRYPOINT ["bash"]
