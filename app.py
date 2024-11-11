from flask import Flask, request, jsonify
import pandas as pd
from flask_cors import CORS
from io import StringIO
import os


app = Flask(__name__)

# Cargar datos desde un archivo CSV (ajusta la ruta según corresponda)
data = pd.read_csv('resultados_finales.csv')

@app.route('/data-info', methods=['GET'])
def get_data_info():
    # Crear la lista de diccionarios con la información de cada columna
    info = [
        {
            "Column": column,
            "Non-Null Count": f"{data[column].count()} non-null",
            "Dtype": str(data[column].dtype)
        }
        for column in data.columns
    ]
    
    # Devolver la información en formato JSON
    return jsonify(info)

@app.route('/grafico-tendencia', methods=['GET'])
def get_grafico_tendencia():
    # Agrupar los datos por año y calcular la predicción promedio de deforestación por año
    tendencia_por_ano = data.groupby('ANIO')['Prediccion_Deforestacion'].mean().reset_index()
    
    # Convertir los datos a una lista de diccionarios para una fácil conversión a JSON
    result = tendencia_por_ano.to_dict(orient='records')
    
    # Devolver los datos como un JSON
    return jsonify(result)

@app.route('/departamentos', methods=['GET'])
def obtener_departamentos():
    # Agrupar por CODIGO_DANE y obtener la primera latitud y longitud para cada código
    resultado = data.groupby('DEPARTAMENTO').first()[['COORDINATES_X', 'COORDINATES_Y']].reset_index()

    # Convertir el resultado a JSON y devolverlo
    # Obtener solo los primeros 100 registros
    #resultado = resultado.head(1)
    codigos_dane = resultado.to_dict(orient='records')
    return jsonify(codigos_dane)

@app.route('/municipios', methods=['GET'])
def obtener_codigos_dane():
    # Agrupar por CODIGO_DANE y obtener la primera latitud y longitud para cada código
    resultado = data.groupby('CODIGO_DANE').first()[['DEPARTAMENTO', 'MUNICIPIO', 'COORDINATES_X', 'COORDINATES_Y']].reset_index()

    # Convertir el resultado a JSON y devolverlo
    codigos_dane = resultado.to_dict(orient='records')
    return jsonify(codigos_dane)

@app.route('/registros', methods=['GET'])
def obtener_registros():
    # Obtener los parámetros de la solicitud
    año = request.args.get('año')
    codigo_dane = request.args.get('codigo_dane')

    # Filtrar los datos por año y código DANE, si están presentes
    filtro = data
    if año:
        filtro = filtro[filtro['ANIO'] == int(año)]
    if codigo_dane:
        filtro = filtro[filtro['CODIGO_DANE'] == int(codigo_dane)]

    print(f'data.count: {data.info}, filtro: {filtro.info}')
    
    # Obtener solo los primeros 100 registros
    filtro = filtro.head(100)

    # Convertir el resultado a JSON y devolverlo
    registros = filtro.to_dict(orient='records')
    return jsonify(registros)

if __name__ == '__main__':
    # Habilitar CORS
    CORS(app)

    #app.run(debug=True)
    ## app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
    port = int(os.environ.get("PORT", 5000))
    app.run(host="0.0.0.0", port=port)
