import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proformas/viewmodels/articuloviewmodel.dart';

class CompararArticuloPage extends StatefulWidget {

  const CompararArticuloPage({super.key,this.model });
  final ArticuloViewModel? model ;

  @override
  State<CompararArticuloPage> createState() => _CompararArticuloPageState();
}

class _CompararArticuloPageState extends State<CompararArticuloPage> {
  var format = NumberFormat.decimalPattern('es');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparación de Precios'),
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                         widget.model?.articulo?.descripcion ?? '' ,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            color: Colors.grey,
                            height: 30,
                            width: 90,
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.blueAccent,
                              height: 30,
                              child: const Center(child: Text('Local',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              color: Colors.green,
                              height: 30,
                              child: const Center(child: Text('Central', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              border: Border.all(
                                width: 1,
                                color: Colors.grey
                              )
                            ),
                            height: 30,
                            width: 90,
                            child: const Center(child: Text('Costo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.blueGrey
                                )
                              ),
                              height: 30,
                              child: Center(child: Text('₡ ${format.format(widget.model?.articulo?.costo ?? 0)}')),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey
                                )
                              ),
                              height: 30,
                              child: Center(child: Text('₡ ${format.format(widget.model?.articulomla?.costo ?? 0)}')),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(
                                width: 1,
                                color: Colors.grey
                              )
                            ),
                            height: 30,
                            width: 90,
                            child: const Center(child: Text('Venta',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey
                                )
                              ),
                              height: 30,
                              child: Center(child: Text('₡ ${format.format(widget.model?.articulo?.venta ?? 0)}')),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color: Colors.grey
                                )
                              ),
                              height: 30,
                              child: Center(child: Text('₡ ${format.format(widget.model?.articulomla?.venta ?? 0)}')),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )
      );
    
  }
}

