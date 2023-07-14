import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  String url = "https://fakestoreapi.com/products"; // URL de la API para obtener la lista de productos

  Future<List<dynamic>> _getListado() async { // _getListado realiza una solicitud HTTP a la API y devuelve una lista de productos.
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData is List) {
        return jsonData;
      } else {
        throw Exception('La respuesta no es una lista válida');
      }
    } else {
      throw Exception('Error con la respuesta de la API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Actividad 2bim',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Listado de API"),
        ),
        body: FutureBuilder<List<dynamic>>(  //Se emplea FutureBuilder para mostrar la lista de productos en la interfaz de usuario.
          future: _getListado(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {  // si esto es verdadero, obtenemos los datos de la Api
              print(snapshot);
              final listado = snapshot.data!;
              return ListView.builder(
                itemCount: listado.length,
                itemBuilder: (context, index) {
                  final product = listado[index];
                  return ListTile(
                    title: Text(product["title"]), // Muestra el título de cada producto
                  );
                },
              );
            } else if (snapshot.hasError) { // si esto es verdadero, no smuestra un mensaje de error al obtener los datos de la Api
              print("Error: ${snapshot.error}");
              return Text("Error al cargar los datos"); // Muestra un mensaje de error si ocurre algún problema al obtener los datos de la Api
            } else {
              return Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se obtienen los datos de la Api
            }
          },
        ),
      ),
    );
  }
}
