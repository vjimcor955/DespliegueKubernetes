# Imagen oficial de Python
FROM python:3.9

# Directorio de trabajo en el contenedor
WORKDIR /app

# Copiar archivos al contenedor
COPY . /app

# Instalar las dependencias necesarias
RUN pip install fastapi uvicorn

# Puerto en el que se mostrará la app
EXPOSE 8000

# Ejecutar la app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
