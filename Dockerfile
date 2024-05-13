# Use a imagem oficial do PHP 8.2 como base
FROM php:8.2-cli

# Instale as dependências necessárias para o Laravel
RUN apt-get update && \
    apt-get install -y git unzip libzip-dev zlib1g-dev libpng-dev libjpeg-dev libfreetype6-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install zip pdo_mysql gd

RUN apt install -y php8.2-mbstring

# Define o diretório de trabalho dentro do contêiner
WORKDIR /var/www/html

# Copie o código do seu projeto Laravel para o diretório de trabalho no contêiner
COPY . /var/www/html

# Instale as dependências do Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt install -y nginx

# Instale as dependências do Composer
RUN composer install --no-scripts --no-autoloader

# Gere o arquivo autoload do Composer
RUN composer dump-autoload --optimize

# Exponha a porta 80 para acesso à aplicação Laravel (se aplicável)
EXPOSE 80

# Comando padrão para executar o servidor web embutido do Laravel
CMD bash -c "composer install && php artisan serve --host=0.0.0.0 --port=80"
