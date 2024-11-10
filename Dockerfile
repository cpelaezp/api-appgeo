# Usa una imagen base de Python con la versión que necesitas
FROM python:3.9-slim

# Establece el directorio de trabajo en la imagen de Docker
WORKDIR /app

# Instala las herramientas de compilación y dependencias del sistema
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    gfortran \
    libatlas-base-dev \
    && rm -rf /var/lib/apt/lists/*

# Copia el archivo requirements.txt a la imagen y lo instala
COPY requirements.txt .

# Instala las dependencias de Python
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copia el resto de los archivos de la aplicación al contenedor
COPY . .

# Expone el puerto en el que Gunicorn ejecutará la aplicación Flask
EXPOSE 8000

# Comando para ejecutar la aplicación usando Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
