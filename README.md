# Despliegue con Kubernetes

Estos son los pasos a seguir para desplegar 5 replicas de un servidor creado con FastAPI controladas por un solo servicio.

## Crear la aplicación FastAPI

Primero creamos un archivo `main.py` en el que estará nuestra API:

```python
from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": "Despliegues de FastAPI con Kubernetes!!"}
```

## Crear el Dockerfile

En la mima carpeta, crear un archivo `Dockerfile` con el siguiente contenido:

```yml
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
```

Construir la imagen con el siguiente comando:

```bash
docker build -t vjimcor955/fastapi-k8s .
```

![1-Build_image](/img/1-Build_image.png)

## Crear los archivos para Kubernetes

Crear un archivo YAML llamado `deployment.yaml`:

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fastapi-deployment
spec:
  replicas: 5 # 5 despliegues
  selector:
    matchLabels:
      app: fastapi
  template:
    metadata:
      labels:
        app: fastapi
    spec:
      containers:
        - name: fastapi-container
          image: vjimcor955/fastapi-k8s # La imagen creada anteriormente
          ports:
            - containerPort: 8000
```

Crear un archivo YAML llamado `service.yaml` para exponer el servicio:

```yml
apiVersion: v1
kind: Service
metadata:
  name: fastapi-service
spec:
  selector:
    app: fastapi
  ports:
    - protocol: TCP
      port: 80 # Puerto externo
      targetPort: 8000 # Puerto del contenedor
  type: LoadBalancer
```

## Aplicar los archivos en Kubernetes

En mi caso estoy usando Docker Desktop en Windows, así que he tenido que habilitar los Kubernetes en _Opciones > Kubernetes_:

![2-Enable_Kubernetes](/img/2-Enable_Kubernetes.png)

Para hacer el despliegue se ejecutan los siguientes comandos:

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

![3-Deployment_and_service](/img/3-Deployment_and_service.png)

Verificamos que esta funcionando y que se muestran en el Docker Desktop:

```bash
kubectl get pods         # Ver los pods en ejecución
kubectl get deployments  # Ver los despliegues
kubectl get services     # Ver el servicio y su IP externa
```

![4-Verification_commands](/img/4-Verification_commands.png)

![5-Docker_Desktop](/img/5-Docker_Desktop.png)
