import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proformas/models/compania.dart';
import 'package:proformas/services/helperservice.dart';
import 'package:proformas/services/notificationservice.dart';
import 'package:proformas/viewmodels/rotacionviewmodel.dart';
import 'package:proformas/widgets/menudrawer.dart';
import 'package:proformas/widgets/modelready.dart';
import 'package:provider/provider.dart';

class RotacionView extends StatefulWidget {
  const RotacionView({super.key, required this.compania});
  final Compania compania;

  @override
  State<RotacionView> createState() => _RotacionViewState();
}

class _RotacionViewState extends State<RotacionView> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
     final Color azul = const Color(0xFF2E64EB);

    return ChangeNotifierProvider(
      create: (_) => Rotacionviewmodel(),
      child: ModelReady<Rotacionviewmodel>(
        onModelReady: (Rotacionviewmodel model) async{
          await model.init();
        },
        child: Consumer<Rotacionviewmodel>(
          builder: ((context,model,child) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                title: Text('Rotacion'),
                elevation: 0,
                leading: IconButton(
                  onPressed: (){
                    scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.menu)
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                    const Text(
                      'Filtros de consulta',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 18),

                    // FECHAS
                    Row(
                      children: [
                        Expanded(
                          child: _fechaButton(
                            titulo: 'Desde',
                            fecha: model.fechaDesde,
                            onTap: () async{
                              DateTime? desde = await HelperService.selectDate(context, model.fechaDesde ?? HelperService.firstDayOfMonth(DateTime.now()));
                              if (desde!=null){
                                model.fechaDesde = desde;
                                model.safeNotify();
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _fechaButton(
                            titulo: 'Hasta',
                            fecha: model.fechaHasta,
                            onTap: () async{
                              DateTime? hasta = await HelperService.selectDate(context, model.fechaHasta ?? DateTime.now());
                              if (hasta!=null){
                                model.fechaHasta = hasta;
                                model.safeNotify();
                              }
                            }
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 22),

                    // CODIGO
                    const Text(
                      'Código del artículo',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: model.codigoController,
                      focusNode: model.codigoFocus,
                      keyboardType: TextInputType.text,
                      onSubmitted: (_) {
                        consultar(context, model);
                      },
                      decoration: InputDecoration(
                        hintText: 'Ingrese o escanee el código',
                        prefixIcon: const Icon(
                          Icons.qr_code_scanner,
                        ),
                        suffixIcon: IconButton(
                          onPressed: ()async{
                            consultar(context, model);
                          }, 
                          icon: Icon(Icons.search),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // RESULTADO
                    const Text(
                      'Resultado de la consulta',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: azul.withOpacity(0.10),
                                  borderRadius:
                                      BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  color: azul,
                                  size: 28,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Descripción del artículo',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      model.descripcion == '' ? 'Aquí aparecerá la descripción' : model.descripcion,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 22),
                          const Divider(),
                          const SizedBox(height: 15),

                          const Text(
                            'Cantidad vendida',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),

                          const SizedBox(height: 8),

                           Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              Text(
                                model.salidas.toString(),
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2E64EB),
                                ),
                              ),
                              SizedBox(width: 8),
                              Padding(
                                padding: EdgeInsets.only(bottom: 7),
                                child: Text(
                                  'unidades',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                   ],
                ),
              ),
              drawer: MenuDrawer(compania: widget.compania,),
            );
          })
        ), 
      ),
    );
  }
}

Widget _fechaButton({
    required String titulo,
    required DateTime? fecha,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  size: 19,
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    formatoFecha(fecha),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> consultar(BuildContext context, Rotacionviewmodel model) async {
    if (!model.validar()) {
      Dlg.showWarningSnackbar(context, 'Hay campos vacíos');
      return;
    }

    try {
      Map<String, dynamic> resp = await model.getSalida();

      if (!context.mounted) return;

      if (resp['statusCode'] == 201) {
        Dlg.showInfo(context, resp['message']);
        model.clearTxt();
      }
    } catch (e) {
      if (context.mounted) {
        Dlg.showError(context, e.toString());
      }
    }
  }

  String formatoFecha(DateTime? fecha) {
    if (fecha == null) return 'Seleccionar fecha';
    return DateFormat('dd/MM/yyyy').format(fecha);
  }




 