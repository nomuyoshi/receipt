FROM ruby:3.0.1

RUN wget https://chromedriver.storage.googleapis.com/91.0.4472.19/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip && rm chromedriver_linux64.zip
RUN mv chromedriver /usr/local/bin/
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt update -y && apt install -y libnss3 google-chrome-stable

WORKDIR /app
RUN useradd -m developer && chown -R developer:developer /app
COPY Gemfile .
COPY Gemfile.lock .
RUN bundle install
COPY . /app
