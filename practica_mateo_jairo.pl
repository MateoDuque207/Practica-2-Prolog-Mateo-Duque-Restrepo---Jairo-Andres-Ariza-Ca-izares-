% Practica 2 Prolog (Mateo Duque - Jairo)

vehiculo(toyota, corolla, sedan, 22000, 2023).
vehiculo(toyota, rav4, suv, 28000, 2022).
vehiculo(toyota, hilux, pickup, 35000, 2024).
vehiculo(toyota, corolla_cross, suv, 26000, 2023).
vehiculo(ford, focus, sedan, 21000, 2022).
vehiculo(ford, ranger, pickup, 39000, 2023).
vehiculo(ford, escape, suv, 31000, 2022).
vehiculo(kia, sportage, suv, 30000, 2023).
vehiculo(nissan, frontier, pickup, 35000, 2023).
vehiculo(mazda, cx5, suv, 32000, 2023).
vehiculo(mazda, 6, sedan, 34000, 2023).
vehiculo(chevrolet, sail, sedan, 17000, 2024).

% Verificamos si un vehiculo se ajusta al presupuesto
cumple_presupuesto(Referencia, PresupuestoMax) :-
    vehiculo(_, Referencia, _, Precio, _),
    Precio =< PresupuestoMax.

% Encuontramos todos los vehiculos de una marca
vehiculos_por_marca(Marca, ListaDeReferencias) :-
    findall(Ref, vehiculo(Marca, Ref, _, _, _), ListaDeReferencias).

% Sumamos los precios de una lista de vehiculos
sumar_precios([], 0).
sumar_precios([vehiculo(_, _, _, Precio, _)|Resto], SumaTotal) :-
    sumar_precios(Resto, SumaDelResto),
    SumaTotal is Precio + SumaDelResto.

% Genera un reporte filtrando por marca, tipo y presupuesto por vehiculo
generar_reporte(Marca, Tipo, Presupuesto, Reporte) :-
    findall(vehiculo(Marca, Ref, Tipo, Precio, Modelo),
            (vehiculo(Marca, Ref, Tipo, Precio, Modelo), Precio =< Presupuesto),
            VehiculosFiltrados),
    sumar_precios(VehiculosFiltrados, ValorTotal),
    ValorTotal =< 1000000,
    Reporte = [vehiculos(VehiculosFiltrados), total(ValorTotal)].

% Calcula el inventario de Sedanes sin pasarse del presupuesto total
reporte_sedanes_presupuesto(PresupuestoTotal, ReporteFinal) :-
    findall(vehiculo(Marca, Ref, sedan, Precio, Modelo),
            vehiculo(Marca, Ref, sedan, Precio, Modelo),
            TodosLosSedanes),

    ordenar_por_precio(TodosLosSedanes, SedanesOrdenados),
    seleccionar_hasta_presupuesto(SedanesOrdenados, PresupuestoTotal, VehiculosSeleccionados),
    sumar_precios(VehiculosSeleccionados, SumaFinal),
    ReporteFinal = [vehiculos(VehiculosSeleccionados), total(SumaFinal)].

% Predicados muy importantes (se usan en otras partes, entonces son fundamentales OJO)

ordenar_por_precio(Lista, ListaOrdenada) :-
    predsort(comparar_precio, Lista, ListaOrdenada).

comparar_precio(Orden, vehiculo(_, _, _, Precio1, _), vehiculo(_, _, _, Precio2, _)) :-
    ( Precio1 < Precio2 -> Orden = < ; Orden = > ).

seleccionar_hasta_presupuesto(ListaVehiculos, Presupuesto, VehiculosFinales) :-
    seleccionar_hasta_presupuesto_acum(ListaVehiculos, Presupuesto, [], VehiculosFinales).

seleccionar_hasta_presupuesto_acum([], _, Acumulador, Acumulador).
seleccionar_hasta_presupuesto_acum([Vehiculo|Resto], Presupuesto, Acumulador, Resultado) :-
    Vehiculo = vehiculo(_, _, _, Precio, _),
    sumar_precios(Acumulador, SumaActual),
    SumaNueva is SumaActual + Precio,
    ( SumaNueva =< Presupuesto ->
        seleccionar_hasta_presupuesto_acum(Resto, Presupuesto, [Vehiculo|Acumulador], Resultado)
    ;
        seleccionar_hasta_presupuesto_acum([], Presupuesto, Acumulador, Resultado)
    ).