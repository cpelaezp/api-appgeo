# Usa una imagen base de Python
FROM python:3.9-slim

# Establece el directorio de trabajo en la imagen de Docker
WORKDIR /app

# Instala las herramientas de compilación y dependencias del sistema, incluyendo numpy y pandas
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    gfortran \
    libatlas-base-dev \
    python3-numpy \
    python3-pandas \
    && rm -rf /var/lib/apt/lists/*

# Copia el archivo requirements.txt a la imagen y omite numpy y pandas para pip
COPY requirements.txt .

# Edita requirements.txt para omitir numpy y pandas (ya instalados con apt-get)
RUN sed -i '/numpy/d' requirements.txt && sed -i '/pandas/d' requirements.txt

# Instala las dependencias de Python restantes
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copia el resto de los archivos de la aplicación al contenedor
COPY . .

# Expone el puerto en el que Gunicorn ejecutará la aplicación Flask
EXPOSE 8000

# Comando para ejecutar la aplicación usando Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
