# Usa una imagen base de Python con la versión que necesitas
FROM python:3.9-slim

# Establece el directorio de trabajo en la imagen de Docker
WORKDIR /app

# Copia el archivo requirements.txt a la imagen y lo instala
COPY requirements.txt .

# Instala las dependencias
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copia el resto de los archivos de la aplicación al contenedor
COPY . .