import 'package:flutter/material.dart';
import 'package:proformas/viewmodels/buscarproveedorviewmodel.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class BuscarProveedorView extends StatelessWidget {
  const BuscarProveedorView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BuscarProveedorViewModel(),
      child: ModelReady<BuscarProveedorViewModel>(
        onModelReady: (BuscarProveedorViewModel model)async{
          model.init();
        },
        child: Consumer<BuscarProveedorViewModel>(
          builder: ((context, model, child) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Buscar proveedor"),
              ),
              body: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    TextField(
                      controller: model.proveedorController,
                      onChanged: (value){

                      },
                      decoration: InputDecoration(
                        hintText: "Buscar proveedor...",
                        prefixIcon: const Icon(Icons.person_search),
                        suffixIcon: IconButton(
                          onPressed: () {
                            model.buscarProveedores();
                          },
                          icon: const Icon(Icons.search),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: ListView.builder(
                        itemCount: model.proveedores.length,
                        itemBuilder: (context, index) {
    
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const CircleAvatar(
                                child: Icon(Icons.business),
                              ),
                              title: Text(
                                model.proveedores[index].razsocial,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Código: ${model.proveedores[index].codProveedor}",
                                  ),
                                  Text(
                                    "Cédula: ${model.proveedores[index].identificacion}",
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.of(context).pop(model.proveedores[index]);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        )
      ),
    );
  }
}