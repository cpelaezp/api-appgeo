# Usa una imagen de Anaconda con Python 3.9
FROM continuumio/miniconda3:4.9.2

# Establece el directorio de trabajo en /app
WORKDIR /app

# Copia el archivo requirements.txt a la imagen
COPY requirements.txt .

# Crea un nuevo ambiente de Conda y instala las dependencias
RUN conda create -n myenv python=3.9 && \
    conda init bash && \
    echo "conda activate myenv" >> ~/.bashrc && \
    . ~/.bashrc && \
    conda install -n myenv --file requirements.txt

# Copia el resto del código en el contenedor
COPY . .

# Expone el puerto 8000 para la aplicación Flask
EXPOSE 4433

# Comando para ejecutar la aplicación usando Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "app:app"]
