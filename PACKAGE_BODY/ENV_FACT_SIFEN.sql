
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."ENV_FACT_SIFEN" is

 e_salir exception;
 
  procedure pp_env_factura is
    v_token varchar2(200);
     
  begin
      -----en caso de haber docuemento sin cdc
    /*  begin
    -- call the procedure
     pp_recuperar_cdc;
     end;*/
  
    --**-----aca recupera el token-------**
    v_token := fp_get_token;
  
    -----recupera los datos que fueron procesado
    -----
    begin
      -- call the procedure
      env_fact_sifen.pp_recuperar_respuestas(v_token);
      -- null;
    end;
  
    begin
      -- carga los registro en una tabla para preparar el envio a la sifen
      env_fact_sifen.pp_get_json_fact;
    end;
  
    /*begin
     --**--aca se hace se llama a procedimiento que se encarga de la conexion y envio de las facturas-----** 
     env_fact_sifen.pp_set_fact(v_token);
    end;*/
  
    begin
      --call the procedure
      env_fact_sifen.pp_anul_doc_el;
    end;
  
    begin
      env_fact_sifen.pp_get_json_remision(null);
    end;
  
    commit;
  exception 
    when e_salir then
      null;
  end pp_env_factura;

-----------------------------------------------
  procedure pp_valida_nc(i_fechahora  in varchar2,
                         i_cod_aso_nc in number,
                         i_doc_clave  in number,
                         i_total      in number,
                         o_indi       out varchar2) is
    
    v_error  varchar2(300);
    e_error_nc exception;
    v_dif_horas number;
    v_fact_estado varchar2(20);
    v_total_fac number;
    v_sald_nc number;
    
  begin

    --VALIDACION PARA FECHA DE EMISION
        select round((sysdate-to_date(i_fechahora,'dd/mm/yyyy HH24:MI:SS'))* 24,2) dif_horas
         into v_dif_horas
        from dual;
        
         if v_dif_horas < 72 then
           --VALIDACION DE LA FACTURA ASOCIADA A LA NC (DEBE DE ESTAR APROBADO)
            begin
              select g.elfa_estado
                into v_fact_estado
                from come_elec_fact g
                where elfa_come_mov_cod= i_cod_aso_nc;
                
            exception
              when no_data_found then
                v_error:='La Factura correspondiente a esta NC aun no ha sido enviada';
                raise e_error_nc;
            end;
            
            if v_fact_estado = 'Aprobado' then
               --VALIDACION DE MONTOS ENTRE LA NC Y LA FACTURA
               begin
                 select nvl(m.movi_impo_mone_ii,0) total
                  into v_total_fac
                 from come_movi m
                 where m.movi_codi = i_cod_aso_nc;
                 
               exception
                 when others then
                   v_error:='Error al consultar el monto de la factura en la validacion de montos nc';
                   raise e_error_nc;
               end;
               
               if i_total = v_total_fac then
                 --VALIDAR SALDO DE LA NC (DEBE SER CERO)
                 begin
                   
                   select c.movi_sald_mone
                   into v_sald_nc
                   from come_movi c
                   where movi_codi = i_doc_clave;
                   
                   /*select c.cuot_sald_mmnn 
                    into v_sald_nc
                    from come_movi_cuot c--
                   where cuot_movi_codi = i_doc_clave;*/
                    
                 exception
                   when others then
                     v_error:='Error al consultar el saldo de la NC, en la valdacion del saldo de la NC';
                     raise e_error_nc;
                 end;
                 
                 if v_sald_nc = 0 then
                   o_indi := 'S';
                 else
                   v_error:='El monto de la NC('||v_sald_nc||') no es igual a cero';
                   raise e_error_nc;
                 end if;                 
               else
                 v_error:='Los Montos de la Factura: ('||v_total_fac ||') y la NC: ('||i_total||') no coinciden';
                 raise e_error_nc;
               end if;
            else
              v_error:='La factura aun no ha sido aprobada, el estado es '|| v_fact_estado;
              raise e_error_nc;
            end if;
         else
           v_error:='La NC ha superado la recepcion de emision, horas trancurridos: '||v_dif_horas ||' hs.';
           raise e_error_nc;
         end if;
         
  exception
    when e_error_nc then
      insert into sifen_error_log
        (logs_fech, logs_user, logs_proc, logs_error_mens, logs_movi_codi)
      values
        (sysdate, fp_user, 'PP_VALIDA_NC', v_error, i_doc_clave);
      o_indi := 'N';
      --commit;
        
    when others then
      v_error := sqlerrm;
      insert into sifen_error_log
        (logs_fech, logs_user, logs_proc, logs_error_mens)
      values
        (sysdate, fp_user, 'PP_VALIDA_NC', v_error);
      o_indi := 'N';
      --commit;
      
  end pp_valida_nc;
  
-----------------------------------------------
  procedure pp_get_json_fact(p_clave in number default null) as
    cursor cur_fact_cab is
      select *
        from fac_electronica_cab fac
       where (fac.doc_clave = p_clave or p_clave is null);
  
    v_clave number;
    cursor cur_fac_det(p_clave number) is
      select * from fac_electronica_det d where d.doc_clave = p_clave;
  
    cursor cur_fac_pagos(i_clave in number) is
      select (case
               when moim_form_pago is null then
                decode(upper(substr(moim_tipo, 1, 3)),
                       'CHE',
                       2,
                       'EFE',
                       1,
                       'TAR',
                       99,
                       99)
               else
                fp.fopa_cod_sifen
             end) tipopago,
             i.moim_impo_mone monto,
             null monedacobro,
             moim_tasa_mone tipocambiocobro,
             0 denominaciontarjeta,
             0 procesadora,
             0 codigoautorizacion,
             0 titular, ---titular de la tarjeta
             0 nrotarjeta,
             movi_mone_codi moneda, -----moneda del documento
             moim_impo_movi, ---importe en la moneda del documento
             movi_tasa_mone tasa, -----tasa del documento principal
             to_number(nvl(lpad(che.cheq_nume, 8, '0'), 0)) nrocheque, ---numero del cheque, completar con 0 a la izquierda hasta llegar 8 cifras
             0 bancoemisor ---banco emisor de la tarjeta
        from come_movi_impo_deta i,
             come_form_pago      fp,
             come_cheq           che,
             come_movi           m
       where i.moim_form_pago = fp.fopa_codi(+)
         and i.moim_cheq_codi = che.cheq_codi(+)
         and i.moim_movi_codi = m.movi_codi
         and i.moim_movi_codi = i_clave;
  
    cursor cur_fac_cuota(i_clave in number) is
      select d.cuot_nume cuota,
             null monedacuota,
             d.cuot_impo_mmnn montocuota,
             to_char(d.cuot_fech_venc, 'dd/mm/yyyy') fechavencimiento,
             d.cuot_movi_codi idcabecera,
             max(d.cuot_nume) over() can_cuota
        from come_movi_cuot d
       where d.cuot_movi_codi = i_clave;
  
    cursor cur_doc_asoc_nc(i_clave in number,p_nume in number, p_clpr_codi in number) is
      select distinct case
                        when d.movi_fech_emis >=
                             to_date('01/08/2022', 'DD/MM/YYYY') then
                        --decode(d.movi_estado_fac_elec, '', 2, timo_tipd_cod)
                         timo_tipd_cod
                        else
                         2
                      end timo_tipd_cod,
                      fac.elfa_nro_control movi_nro_cdc_fac,
                      replace(to_char(d.movi_nume_timb),' ','') timbrado,
                      
                      '00' || substr(d.movi_nume, 1, 1) || '-' ||
                      substr(d.movi_nume, 2, 3) || '-' ||
                      substr(d.movi_nume, 5, 11) numerocomprobante,
                      to_char(d.movi_fech_emis, 'dd/mm/yyyy HH24:MI:SS') movi_fech_emis
        from come_movi d, come_tipo_movi g, come_elec_fact fac
       where d.movi_timo_codi = g.timo_codi
          and d.movi_timo_codi<>9
         and d.movi_codi = fac.elfa_come_mov_cod(+)
          and d.movi_clpr_codi=  p_clpr_codi
        and ( d.movi_codi =i_clave or d.movi_codi_padr = i_clave  )
         /*and d.movi_nume in (select
         de.movi_nume 
        from
        come_movi de,
        come_movi_cuot cu,
        come_movi pa,
        come_movi_cuot_canc ca,
        come_tipo_movi tm
        where de.movi_codi                = cu.cuot_movi_codi
        and pa.movi_codi               = ca.canc_movi_codi
        and ca.canc_cuot_movi_codi     = cu.cuot_movi_codi
        and ca.canc_cuot_fech_venc     = cu.cuot_fech_venc
        and ca.canc_tipo               = cu.cuot_tipo
        and  pa.movi_clpr_codi=  p_clpr_codi
        and   de.movi_timo_codi =2
        and  pa.movi_nume=p_nume
        
        
        )*/
        
        ;
  
    v_clob   clob;
    v_token  varchar(500);
    v_codigo number;
    v_error  varchar2(300);
    v_correo varchar2(20);
    v_indi_nc varchar2(2);
    
  begin
    
  --raise e_salir;
  
    --**-----aca recupera el token-------**
    v_token := fp_get_token; ------**
    --**---------------------------------**
  
    --**----aca genera en formato json las facturas a enviar-----**
    for c in cur_fact_cab loop
      
      --VALIDACION NC
      --**---------------------------------**                   
      if c.tm = 9 then
        pp_valida_nc(c.fechahora,
                     c.cod_aso_nc,
                     c.doc_clave,
                     c.total,
                     v_indi_nc);
        v_indi_nc := nvl(v_indi_nc,'N');
      else
        v_indi_nc :='S';
      end if;
      --**---------------------------------**
      
      if v_indi_nc = 'S' then
    
      v_clave := c.doc_clave;
    
      apex_json.initialize_clob_output;
      apex_json.open_array;
      apex_json.open_object;
      apex_json.write('tipoDocElectronico', c.tipodocelectronico);
      apex_json.write('timbrado',  nvl(c.timbrado,'15734738'), true);
      apex_json.write('fechaIniTimb',
                      nvl(c.fechainitimb, '5/7/2022'),
                      true);
      apex_json.write('numeroComprobante', c.numerocomprobante, true);
      apex_json.write('fechaHora', c.fechahora, true);
      apex_json.write('tipoTransaccion', c.tipotransaccion, true);
      apex_json.write('tipoImpuestoAfectado', c.tipoimpuestoafectado, true);
      apex_json.write('tipoOperacion', c.tipooperacion, true);
      apex_json.write('moneda', c.moneda, true);
      if c.movi_tasa_mone <> 2 then
        apex_json.write('tipoCambio', c.tipo_cambio, true);
      else
        apex_json.write('tipoCambio', c.movi_tasa_mone, true);
      end if;
    
      apex_json.write('tipoReceptor', c.tiporeceptor, true);
      apex_json.write('tipoContribuyenteReceptor',
                      c.tipocontribuyentereceptor,
                      true);
      apex_json.write('tipoDocumentoReceptor',
                      c.tipodocumentoreceptor,
                      true);
      apex_json.write('rucReceptor', c.rucreceptor, true);
      apex_json.write('nombreRazonSocial', c.nombrerazonsocial, true);
      apex_json.write('correoElectronico',
                      v_correo /*'veramarisa676@gmail.com'*/,
                      true);
      apex_json.write('telefono', c.telefono, true);
      apex_json.write('direccion', c.direccion, true);
      apex_json.write('condicionVenta', c.condicionventa, true);
      apex_json.write('entregaInicial', c.entregainicial, true);
      if c.tipodocelectronico not in (5, 6) then
      
        apex_json.write('cuotas', c.cuotas, true);
      
      end if;
    
      apex_json.write('plazos', c.plazos, true);
    
      if c.cant_decimales = 0 and c.movi_mone_codi = 1 then
        --por validaciones de la set , se tiene que improvisar a 2 decimales algunos casos que nos coincide la suma cab/det
        apex_json.write('gravada10', c.gravada10, true);
        apex_json.write('iva10', c.iva10, true);
        apex_json.write('gravada5', c.gravada5, true);
        apex_json.write('iva5', c.iva5, true);
      else
        apex_json.write('gravada10', c.tot_gravada10_2decimales, true);
        apex_json.write('iva10', c.tot_iva10_2decimales, true);
        apex_json.write('gravada5', c.tot_gravada5_2decimales, true);
        apex_json.write('iva5', c.tot_iva5_2decimales, true);
      end if;
    
      apex_json.write('exento', nvl(c.exento, 0), true);
      apex_json.write('totalDescuento', c.totaldescuento, true);
    
      apex_json.write('total',
                      case when c.movi_mone_codi = 1 then c.total else
                      round(c.total, 2) end,
                      true);
    
      if c.tipodocelectronico in (5, 6) then
        ---para las prueba trabajar el la vista
        apex_json.write('motivoEmision', c.motivoemision, true);
      end if;
    
      apex_json.write('infoInteresEmisor', c.infointeresemisor, true);
      apex_json.write('infoInteresFiscal', c.infointeresfiscal, true);
      apex_json.write('codigoDepartamentoReceptor',
                      c.codigodepartamentoreceptor,
                      true);
      apex_json.write('departamentoReceptor', c.departamentoreceptor, true);
      apex_json.write('codigoDistritoRecptor',
                      c.codigodistritorecptor,
                      true);
      apex_json.write('distrito', c.distrito, true);
      apex_json.write('codigoCiudadReceptor', c.codigociudadreceptor, true);
      apex_json.write('descripcionCiudadReceptor',
                      c.descripcionciudadreceptor,
                      true);
      apex_json.write('celularReceptor', c.celularreceptor, true);
      apex_json.write('codigoCliente', c.codigocliente, true);
      apex_json.write('codigoPais', c.codigopais);
      apex_json.write('numeroCasaReceptor', c.numerocasareceptor, true);
      apex_json.write('nombreFantasiaReceptor',
                      c.nombre_fantasia_receptor,
                      true);
      apex_json.write('enviar', 'n');
    
      ---**------aca genera el arreglo del detalle---**---
      apex_json.open_array('detalle');
    
      for d in cur_fac_det(c.doc_clave) loop
      
        if d.total > 0 then
          apex_json.open_object;
        
          apex_json.write('codigo', d.codigo, true);
          apex_json.write('cantidad', d.cantidad, true);
          apex_json.write('unidadMedida', d.unidadmedida, true);
          apex_json.write('descripcion', d.descripcion, true);
          apex_json.write('precioUnitario', d.preciounitario, true);
          apex_json.write('importeItems', d.importeitems, true);
          apex_json.write('porcentajeDescuento',
                          d.porcentajedescuento,
                          true);
          apex_json.write('importeDescItems', d.importedescitems, true);
          apex_json.write('totalDescuentoItems',
                          d.totaldescuentoitems,
                          true);
          apex_json.write('tasaImpuesto', d.tasaimpuesto, true);
        
          if c.cant_decimales = 0 and c.movi_mone_codi = 1 then
            apex_json.write('gravado10', d.gravado10_0decimales, true);
            apex_json.write('iva10', d.iva10_0decimales, true);
            apex_json.write('gravado5', d.gravado5_0decimales, true);
            apex_json.write('iva5', d.iva5_0decimales, true);
          else
            apex_json.write('gravado10', d.gravado10_2decimales, true);
            apex_json.write('iva10', d.iva10_2decimales, true);
            apex_json.write('gravado5', d.gravado5_2decimales, true);
            apex_json.write('iva5', d.iva5_2decimales, true);
          end if;
        
          apex_json.write('exento', nvl(d.exento, 0), true);
          apex_json.write('total',
                          case when c.movi_mone_codi = 1 then d.total else
                          round(d.total, 2) end,
                          true);
        
          apex_json.close_object;
        end if;
      end loop;
    
      apex_json.close_array;
      --**-----------------------------------------------**
    
      ---***----aca genera el arreglo de los pago en caso de haber uno -----**
      if c.tipodocelectronico not in (5, 6) then
        apex_json.open_array('pagos');
        for p in cur_fac_pagos(i_clave => c.doc_clave) loop
          apex_json.open_object;
          apex_json.write('tipoPago', p.tipopago, true);
        
          apex_json.write('monto',
                          case when p.moneda <> 1 then p.moim_impo_movi else
                          p.monto end,
                          true);
          apex_json.write('monedaCobro', c.moneda /* p.monedacobro*/, true); --pruebaa
          if c.movi_mone_codi = 2 then
            apex_json.write('tipoCambioCobro', p.tasa, true);
          else
            apex_json.write('tipoCambioCobro', 0, true);
          end if;
          apex_json.write('denominacionTarjeta',
                          p.denominaciontarjeta,
                          true);
          apex_json.write('procesadora', p.procesadora, true);
          apex_json.write('codigoAutorizacion', p.codigoautorizacion, true);
          apex_json.write('titular', p.titular, true);
          apex_json.write('nroTarjeta', p.nrotarjeta, true);
          apex_json.write('nroCheque', p.nrocheque, true);
          apex_json.write('bancoEmisor', p.bancoemisor, true);
          apex_json.close_object;
        end loop;
        apex_json.close_array;
        --**------------------------------------------------------***
        --**-----aca crea el arreglo de las cuota en caso de haber uno--***
        if c.cuotas > 0 then
          apex_json.open_array('detalleCuotas');
          for cuo in cur_fac_cuota(i_clave => c.doc_clave) loop
            apex_json.open_object;
          
            apex_json.write('cuota', cuo.can_cuota, true);
            apex_json.write('monedaCuota', c.moneda, true);
            apex_json.write('montoCuota', cuo.montocuota, true);
            apex_json.write('fechaVencimiento', cuo.fechavencimiento, true);
            apex_json.write('idCabecera', c.doc_clave, true);
          
            apex_json.close_object;
          
          end loop;
        
          apex_json.close_array;
        
        end if;
      
        --**--------------------------------****
      else
      
        apex_json.open_array('documentos');
        for nc in cur_doc_asoc_nc(i_clave => c.cod_aso_nc,p_nume => c.movi_nume,p_clpr_codi =>c.clpr_codi) loop
          apex_json.open_object;
        
          apex_json.write('comprobanteAsociado', nc.timo_tipd_cod, true);
        
          --**-----en caso de que el documento pricipal sea 2=impreso se precenta el timbrado y nro doc
          if nc.timo_tipd_cod = 2 then
            apex_json.write('timbrado', nc.timbrado);
            apex_json.write('numeroComprobante', nc.numerocomprobante);
            apex_json.write('fechaDocumento', nc.movi_fech_emis);
          else
            apex_json.write('cdc', nc.movi_nro_cdc_fac, true);
          end if;
          apex_json.close_object;
        end loop;
      
        apex_json.close_array;
      
      end if;
    
      apex_json.close_object;
      apex_json.close_array;
      v_clob := apex_json.get_clob_output;
      apex_json.free_output;
    
      begin
        select nvl(max(d.elfa_codi), 0) + 1
          into v_codigo
          from come_elec_fact d;
      end;
    
      --**----se hace insert correspondiente------------------------------**--     
      begin
        insert into come_elec_fact g
          (g.elfa_codi,
           g.elfa_come_mov_cod,
           elfa_nro_doc,
           elfa_indi_envi,
           elfa_fech_regi,
           
           elfa_fac_env,
           elfa_user_regi,
           elfa_nro_timbrado,
           elfa_tipo_comproban,
           elfa_timo_codi)
        values
          (v_codigo,
           c.doc_clave,
           c.numerocomprobante,
           'P',
           sysdate,
           v_clob,
           fp_user,
           c.timbrado,
           c.tipodocelectronico,
           c.tm);
        --**-------------------------------------------------**--
      exception
        when others then
          raise_application_error(-20003,
                                  'Error en tabla COME_ELEC_FACT. ' ||
                                  sqlerrm);
      end;
    
    end if;
    
    end loop;
    commit;
    -------------
  
    begin
      --**-- aca se hace se llama a procedimiento que se encarga de la conexion y envio de las facturas-----** 
      --call the procedure
      env_fact_sifen.pp_set_fact(v_token, p_clave);
    
    end;
  
    --enviamos la factura al cliente
    if p_clave is not null then
    
      begin
        env_fact_sifen.pp_envi_fact_vent(p_codi => p_clave);
      exception
        when others then
          null;
      end;
    
    end if;
  
  exception
     when e_salir then
      null;
    when others then
      v_error := sqlerrm;
      insert into sifen_error_log
        (logs_fech, logs_user, logs_proc, logs_error_mens)
      values
        (sysdate, fp_user, 'PP_GET_JSON_FACT', v_error);
   
  end pp_get_json_fact;

  function fp_get_token return varchar2 is
    req             utl_http.req;
    res             utl_http.resp;
    url             varchar2(4000) := 'http://test.kigafe.com:8082/dpy-testfe/rest/login';--'https://prod.kigafe.com:8444/dpy-prodfe/rest/login';
    buffer          varchar2(32767);
    v_credenciales  varchar2(32767);
    v_return        clob;
    v_request_token varchar2(200);
    v_error         varchar2(300);
  
  begin
    apex_json.initialize_clob_output;
    apex_json.open_object;
    apex_json.write('username', 'alarmassa');
    apex_json.write('password', 'alarmassa123.');
  
    apex_json.close_object;
    v_credenciales := apex_json.get_clob_output;
    apex_json.free_output;
    sys.utl_http.set_wallet('file:/oracle/wallet', 'Alarmas2022');
    req := utl_http.begin_request(url, 'POST', 'HTTP/1.1');
    utl_http.set_header(req, 'User-Agent', 'Mozilla/4.0');
    utl_http.set_header(req, 'Content-Type', 'application/json');
    utl_http.set_header(req, 'Content-Length', length(v_credenciales));
    utl_http.write_text(req, v_credenciales);
    res := utl_http.get_response(req);
    begin
    
      loop
        utl_http.read_text(res, buffer);
        v_return := buffer;
      end loop;
    
      utl_http.end_response(res);
    
    exception
      when utl_http.end_of_body then
        utl_http.end_response(res);
      when others then
        dbms_output.put_line('Error ' || sqlerrm);
    end;
  
    select json_value(v_return, '$.accessToken') token
      into v_request_token
      from dual;
  
    return v_request_token;
  
  exception
    when others then
      v_error := sqlerrm;
      insert into sifen_error_log
        (logs_fech, logs_user, logs_proc, logs_error_mens)
      values
        (sysdate, fp_user, 'FP_GET_TOKEN', v_error);
      return v_request_token;
    
  end fp_get_token;

  procedure pp_set_fact(p_token in varchar2,
                        p_clave in number default null) is
  
    -- v_token       varchar2(200) := p_token;
    v_cod_control varchar2(2000);
    v_estado      varchar(200);
    v_desc_estado varchar(500);
    v_qr          varchar(2000);
    v_qr_code     blob;
    v_error       varchar2(300);
  
    --req utl_http.req;
    --res utl_http.resp;
    --url varchar2(32767) := 'https://prod.kigafe.com:8444/dpy-prodfe/rest/comprobantes/uploadasync';
    url varchar2(32767) := 'http://test.kigafe.com:8082/dpy-testfe/rest/comprobantes/uploadasync';
  
    --buffer    varchar2(32767);
    --v_content varchar2(32767);
    v_return              clob;
    texto                 varchar2(5000);
    v_ensm_codi           number;
    v_descripcion         varchar2(200);
    v_ensm_clpr_desc      varchar2(200);
    v_ensm_clpr_tele      varchar2(200);
    v_ensm_clpr_codi      number;
    v_ensm_clpr_codi_alte number;
  
    X_CONT_ERROR1 NUMBER := 0;
    X_CONT_ERROR2 NUMBER := 0;
  
  begin
    
 -- raise e_salir;
  
    for i in (select elfa_codi,
                     elfa_come_mov_cod,
                     elfa_fac_env,
                     elfa_nro_doc
                from come_elec_fact
               where elfa_indi_envi = 'P'
                 and elfa_nro_control is null
                 and (elfa_come_mov_cod = p_clave or p_clave is null)) loop
    
      /*   v_content := i.elfa_fac_env;
      
       req := utl_http.begin_request(url, 'post', 'http/1.1');
       utl_http.set_header(req, 'user-agent', 'mozilla/4.0');
       utl_http.set_header(req, 'content-type', 'application/json');
       utl_http.set_header(req, 'content-length', length(v_content));
       utl_http.set_header(req, 'authorization', 'bearer ' || p_token);
       utl_http.set_transfer_timeout(req,70);
       utl_http.write_text(req, v_content);
      
       res := utl_http.get_response(req);
       begin
        loop
           utl_http.read_text(res, buffer);
           v_return := buffer;
         end loop;
       
         utl_http.end_response(res);
       
      exception 
        when utl_http.end_of_body then
           utl_http.end_response(res);
         when others then
           dbms_output.put_line('error '||sqlerrm);
       end;*/
    
      -----------------------------------------------------------------------------
    
      apex_web_service.g_request_headers.delete();
    
      apex_web_service.g_request_headers(1).name := 'USER-AGENT';
      apex_web_service.g_request_headers(1).value := 'MOZILLA/4.0';
      apex_web_service.g_request_headers(2).name := 'Authorization';
      apex_web_service.g_request_headers(2).value := 'Bearer ' || p_token;
    
      apex_web_service.g_request_headers(3).name := 'Content-Type';
      apex_web_service.g_request_headers(3).value := 'application/json';
    
      v_return := apex_web_service.make_rest_request(p_url         => url,
                                                     p_http_method => 'POST',
                                                     p_wallet_path => 'file:/oracle/wallet',
                                                     p_wallet_pwd  => 'Alarmas2022',
                                                     p_body        => i.elfa_fac_env);
    
      ------------------------------------------------------------------------------
    
      begin
      
        select json_value(v_return, '$.codigoControl'),
               json_value(v_return, '$.estado'),
               json_value(v_return, '$.descripcionResultado'),
               json_value(v_return, '$.qr')
          into v_cod_control, v_estado, v_desc_estado, v_qr
          from dual;
        if v_qr is not null then
          v_qr_code := make_qr.qr_bin(v_qr);
        end if;
        --  if res.status_code = 200 then
        if apex_web_service.g_status_code = 200 then
          begin
            update come_elec_fact
               set elfa_respuesta   = nvl(elfa_respuesta, '') || v_return,
                   elfa_qr_code     = v_qr_code,
                   elfa_desc_resul  = v_desc_estado,
                   elfa_nro_control = v_cod_control,
                   elfa_estado      = v_estado,
                   elfa_indi_envi   = 'E', --eviado
                   elfa_fech_regi   = sysdate,
                   elfa_qr          = v_qr
             where elfa_codi = i.elfa_codi
               and elfa_come_mov_cod = i.elfa_come_mov_cod;
          exception
            when others then
              v_error := sqlerrm;
            
              insert into sifen_error_log
                (logs_fech, logs_user, logs_proc, logs_error_mens)
              values
                (sysdate, fp_user, 'PP_SET_FACT', v_error);
          end;
        
          if v_estado = 'Error' then
            ---------------ticket nro #755
            X_CONT_ERROR1 := X_CONT_ERROR1 + 1;
          end if;
        
          /* if v_estado = 'Error' then
           
          /* begin
             -- call the procedure
             env_fact_sifen.pp_enviar_sms_error(v_desc_estado ||
                                                ' en la factura nro ' ||
                                                i.elfa_nro_doc);
           end;*/
        
          ------------------------lv 01/03/2023       
          /*    select smco_text, smco_desc
                     into texto, v_descripcion
                     from come_envi_sms_conf
                    where smco_codi = 17;
                    
                      
             select t.clpr_desc, t.clpr_tele, clpr_codi, t.clpr_codi_alte
               into v_ensm_clpr_desc, v_ensm_clpr_tele,v_ensm_clpr_codi,v_ensm_clpr_codi_alte
             from come_clie_prov t
             where clpr_codi = 10062238301;
          
              v_ensm_codi           := sec_come_envi_sms.nextval;
          
          
              insert into come_envi_sms
                (ensm_codi,
                 ensm_fech_envi,
                 ensm_user_envi,
                 ensm_clpr_codi,
                 ensm_clpr_tele,
                 ensm_text,
                 ensm_tipo,
                 ensm_indi_envi,
                 ensm_fech_regi,
                 ensm_tipo_desc,
                 ensm_clpr_desc,
                 ensm_clpr_codi_alte,
                 ensm_smco_codi)
              values
                (v_ensm_codi,
                 sysdate,
                 'ALARMAS',
                 v_ensm_clpr_codi,
                 v_ensm_clpr_tele,
                 texto,
                 'A',
                 'N',
                 sysdate,
                 v_descripcion,
                 v_ensm_clpr_desc,
                 v_ensm_clpr_codi_alte,
                 17);
            
            
            
          end if;*/
        
        else
        
          --raise_application_error(-20001,'soy un error: '|| res.status_code);
          begin
            update come_elec_fact
               set elfa_respuesta   = v_return,
                   elfa_indi_envi   = 'E',
                   elfa_qr          = v_qr,
                   elfa_desc_resul  = v_desc_estado,
                   elfa_nro_control = v_cod_control,
                   elfa_estado      = v_estado,
                   elfa_fech_regi   = sysdate
             where elfa_codi = i.elfa_codi
               and elfa_come_mov_cod = i.elfa_come_mov_cod;
          
            X_CONT_ERROR2 := X_CONT_ERROR2 + 1; ---------------ticket nro #755
            ----envio de avis de error de facturar  
            /* begin
              -- call the procedure
              env_fact_sifen.pp_enviar_sms_error('Error en el envio de la factura nro ' ||
                                                 i.elfa_nro_doc);
            end;*/
          
          exception
            when others then
            
              /* raise_application_error(-20005,
              'Error al actualizar en la tabla de envio de facturas');*/
              v_error := sqlerrm;
            
              insert into sifen_error_log
                (logs_fech, logs_user, logs_proc, logs_error_mens)
              values
                (sysdate, fp_user, 'PP_SET_FACT', v_error);
            
          end;
        
        end if;
      
      end;
      commit;
    
    end loop;
    ---------------ticket nro #755
    IF X_CONT_ERROR1 IS NOT NULL THEN
      env_fact_sifen.pp_enviar_sms_error('Exiten:' || X_CONT_ERROR1 ||
                                         ' al enviar a la sifen1');
    END IF;
  
    IF X_CONT_ERROR2 IS NOT NULL THEN
      env_fact_sifen.pp_enviar_sms_error('Exiten:' || X_CONT_ERROR2 ||
                                         ' al enviar a la sifen2');
    END IF;
  
  exception
    when e_salir then 
      null;
    when others then
      v_error := sqlerrm;
      env_fact_sifen.pp_enviar_sms_error('Error en el procedimiento PP_SET_FACT');
    
      insert into sifen_error_log
        (logs_fech, logs_user, logs_proc, logs_error_mens)
      values
        (sysdate, fp_user, 'PP_SET_FACT', v_error);
    
  end pp_set_fact;

  procedure pp_anul_doc_el is
  
    req       utl_http.req;
    res       utl_http.resp;
    url       varchar2(4000) := 'https://test.kigafe.com:8444/dpy-prodfe/rest/comprobantes/cancelar';
    buffer    varchar2(32767);
    v_content varchar2(32767);
    v_return  clob;
    v_token   varchar2(200);
    v_estado  varchar(50);
    v_error   varchar2(300);
  
    cursor c_anul is
      select l.elfa_nro_control cdc, l.elfa_codi, l.elfa_come_mov_cod
        from come_movi_anul f, come_elec_fact l
       where l.elfa_nro_doc =
             '00' || substr(f.anul_nume, 1, 1) || '-' ||
             substr(f.anul_nume, 2, 3) || '-' || substr(f.anul_nume, 5, 11)
         and l.elfa_nro_timbrado = f.anul_nume_timb
         and f.anul_timo_codi = l.elfa_timo_codi
         and f.anul_fech_movi between general_skn.fl_peri_act_ini and
             general_skn.fl_peri_sgt_fin
         and l.elfa_indi_envi <> 'C';
  
  begin
    v_token := fp_get_token;
  
    for i in c_anul loop
    
      apex_json.initialize_clob_output;
      apex_json.open_array;
      apex_json.open_object;
      apex_json.write('cdc', i.cdc, true);
      apex_json.close_object;
      apex_json.close_array;
      v_content := apex_json.get_clob_output;
      apex_json.free_output;
    
      sys.utl_http.set_wallet('file:/oracle/wallet', 'Alarmas2022');
      req := utl_http.begin_request(url, 'POST', 'HTTP/1.1');
      utl_http.set_header(req, 'User-Agent', 'Mozilla/4.0');
      utl_http.set_header(req, 'Content-Type', 'application/json');
      utl_http.set_header(req, 'Content-Length', length(v_content));
      utl_http.set_header(req, 'Authorization', 'Bearer ' || v_token);
      --utl_http.set_transfer_timeout(req,70);
      utl_http.write_text(req, v_content);
    
      res := utl_http.get_response(req);
      begin
        loop
          utl_http.read_text(res, buffer);
          v_return := v_return || buffer;
        end loop;
      
        utl_http.end_response(res);
      
      exception
        when utl_http.end_of_body then
          utl_http.end_response(res);
        when others then
          dbms_output.put_line('Error ' || sqlerrm);
      end;
    
      select json_value(v_return, '$.estado') into v_estado from dual;
    
      if res.status_code = 200 then
      
        begin
          update come_elec_fact
             set elfa_estado    = v_estado,
                 elfa_indi_envi = substr(v_estado, 1, 1)
           where elfa_codi = i.elfa_codi
             and elfa_come_mov_cod = i.elfa_come_mov_cod;
        
        exception
          when others then
            /*raise_application_error(-20004,
            'Error al actualizar en la tabla de envio de facturas ' ||
            sqlerrm);*/
            v_error := sqlerrm;
            insert into sifen_error_log
              (logs_fech, logs_user, logs_proc, logs_error_mens)
            values
              (sysdate, fp_user, 'PP_SET_FACT', v_error);
          
        end;
      
        commit;
      end if;
    
    end loop;
  exception
    when others then
      v_error := sqlerrm;
      insert into sifen_error_log
        (logs_fech, logs_user, logs_proc, logs_error_mens)
      values
        (sysdate, fp_user, 'PP_ANUL_DOC_EL', v_error);
    
  end pp_anul_doc_el;

  procedure pp_recuperar_respuestas(p_token in varchar2) is
  
    v_url       varchar2(4000);
    l_json_doc  clob;
    v_error     varchar2(300);
    v_resultado varchar2(4000);
    --v_token    varchar2(4000);
  
    v_estado     varchar2(200);
    X_CONT_ERROR NUMBER := 0;
  begin
    --v_token := env_fact_sifen.fp_get_token;
  
    for i in (select f.elfa_codi,
                     f.elfa_come_mov_cod,
                     f.elfa_nro_doc,
                     f.elfa_tipo_comproban,
                     nvl(f.elfa_nro_timbrado,'15734738') elfa_nro_timbrado,
                     f.elfa_desc_resul,
                     f.elfa_estado
                from come_elec_fact f
               where nvl(f.elfa_indi_envi, 'E') in ('E', 'P', 'R')
                -- and f.elfa_estado<>'Error'
                 and elfa_fech_regi >= to_date('01/08/2022', 'DD/MM/YYYY')) loop
    
      --v_url := 'https://prod.kigafe.com:8444/dpy-prodfe/rest/comprobantes/consultacomprobantetimbrado?comprobante=' ||
      v_url := 'https://test.kigafe.com:8082/dpy-testfe/rest/comprobantes/consultacomprobantetimbrado?comprobante=' ||
               i.elfa_nro_doc || '&timbrado=' || i.elfa_nro_timbrado ||
               '&tipoComprobante=' || i.elfa_tipo_comproban || '';
      apex_web_service.g_request_headers(1).name := 'Authorization';
      apex_web_service.g_request_headers(1).value := 'Bearer ' || p_token;
      l_json_doc := (apex_web_service.make_rest_request(p_url         => v_url,
                                                        p_http_method => 'GET',
                                                        p_wallet_path => 'file:/oracle/wallet',
                                                        p_wallet_pwd  => 'Alarmas2022'));
    
      begin
        select json_value(l_json_doc, '$.estado'),
               json_value(l_json_doc, '$.descripcionResultado')
        
          into v_estado, v_resultado
          from dual;
      exception
        when others then
          v_estado := null;
      end;
      if i.elfa_desc_resul not like '%Error%' then
        if v_estado <> 'Rechazado' then
          v_resultado := i.elfa_desc_resul;
        end if;
      end if;
    
      if v_estado is not null and v_estado <> 'Pendiente' then
        begin
          update come_elec_fact
             set elfa_estado     = v_estado,
                 elfa_indi_envi  = substr(v_estado, 1, 1),
                 elfa_desc_resul = v_resultado
           where elfa_codi = i.elfa_codi
             and elfa_come_mov_cod = i.elfa_come_mov_cod;
        end;
      end if;
    
      ----enviar mensaje en caso de la factura ser rechazado...
      if v_estado = 'Rechazado' and i.elfa_estado <> 'Rechazado' then
      
        ---------------ticket nro #755
        X_CONT_ERROR := X_CONT_ERROR + 1;
        /* env_fact_sifen.pp_enviar_sms_error('La factura ha sido ' ||
        v_estado || ' nro ' ||
        i.elfa_nro_doc || ' ' ||
        v_estado);*/
      
        null;
      
      end if;
      commit;
    end loop;
  
    IF X_CONT_ERROR IS NOT NULL THEN
      env_fact_sifen.pp_enviar_sms_error('Exiten:' || X_CONT_ERROR ||
                                         ' al recuperar datos');
    END IF;
  
  exception
    when others then
      v_error := sqlerrm;
      insert into sifen_error_log
        (logs_fech, logs_user, logs_proc, logs_error_mens)
      values
        (sysdate, fp_user, 'PP_RECUPERAR_RESPUESTAS', v_error);
  end pp_recuperar_respuestas;

  procedure pp_get_json_remision(p_clave in number) is
    v_token  varchar2(200);
    v_clob   clob;
    v_codigo number;
    cursor c_remision is
      select 7 tipodocelectronico,
             nvl(f.movi_nume_timb, '15734738') timbrado,
             nvl(to_char(f.movi_fech_inic_timb, 'DD/MM/YYYY'), '05/07/2022') fechainitimb,
             '00' || substr(f.movi_nume, 1, 1) || '-' ||
             substr(f.movi_nume, 2, 3) || '-' || substr(f.movi_nume, 5, 11) numerocomprobante,
             to_char(f.movi_fech_emis, 'dd/mm/yyyy HH24:MI:SS') fechahora,
             null tipotransaccion,
             o.mone_ind_den_iso_4217 moneda,
             null tipocambio,
             1 tiporeceptor,
             2 tipocontribuyentereceptor,
             f.movi_cont_tran_ruc rucreceptor,
             f.movi_cont_tran_nomb nombrerazonsocial,
             /*'administracion@alarmas.com.py'*/
             null correoelectronico,
             --null telefono ,
             'LOMAS VALENTINAS NRO. 1220 SAN LORENZO - PARAGUAY' direccion,
             null condicionventa,
             --null entregainicial,
             --null cuotas,
             --null plazos,
             nvl(f.movi_grav10_mone, 0) gravada10,
             nvl(f.movi_iva10_mone, 0) iva10,
             nvl(f.movi_grav5_mone, 0) gravada5,
             nvl(f.movi_iva5_mone, 0) iva5,
             nvl(f.movi_exen_mone, 0) exento,
             0 totaldescuento,
             nvl(f.movi_impo_mone_ii, 0) total,
             
             1 motivoemision,
             1 tipoimpuestoafectado,
             1 tipooperacion,
             --"infointeresemisor": null,
             --"infointeresfiscal": null,
             
             /*12 codigodepartamentoreceptor,
             'CENTRAL' departamentoreceptor,
             165 codigodistritorecptor,
             'SAN LORENZO' distrito,
             6010 codigociudadreceptor,
             'SAN LORENZO' descripcionciudadreceptor,*/
             
                  
             11 codigodepartamentoreceptor,
             'ALTO PARANA' departamentoreceptor,
             145 codigodistritorecptor,
             'CIUDAD DEL ESTE' distrito,
              3383 codigociudadreceptor,
              'CIUDAD DEL ESTE' descripcionciudadreceptor,
           
     
             
             
             --"codigodistritorecptor": "1",
             --"distrito": "asuncion (distrito)",
             -- "codigociudadreceptor": "1",
             -- "descripcionciudadreceptor": "asuncion (distrito)",
             --  "celularreceptor": null,
             -- "codigocliente": null,
             'PRY' codigopais,
             --"numerocasareceptor": "0",
             --"nombrefantasiareceptor": null,
             --"tipoanticipo": null,
             --"datosremision": ,
             --datos principales de la remision
             7 imoteminr,
             2 irespeminr,
             --dfecem": "2020/01/08",
             2 itiptrans,
             1 imodtrans,
             3 irespflete,
             'DAP' ccondneg,
             -- "dnumanif": null,
             -- "dnudespimp":null,
             to_char(r.remi_fech_inic_tras, 'yyyy/mm/dd') dinitras,
             to_char(r.remi_fech_term_tras, 'yyyy/mm/dd') dfintras,
             null dtivehtras,
             null dmarveh,
             f.movi_codi doc_clave,
             r.remi_codi,
             2 dtipidenveh,
             null dnroidveh,
             REMI_NUME_CHAP dnromatveh,
             null dnrovuelo,
             1 inattrans,
             null dnomtrans,
             null dructrans,
             null itipidtrans,
             null dnumidtrans,
             'Domicilio fiscal del transportista' dDomFisc,
             'PRY' cnactrans,
             r.remi_ruc_tran dnumidchof,
             r.remi_nomb_tran dnomchof,
             'Asuncion py' ddirchof,
             'CIUDAD DEL ESTE' dDirLocEnt,
             0 dNumCasEnt,
             
             REMI_TRAN_CODI
      
        from come_remi r, come_movi f, come_mone o, come_elec_fact fe
       where r.remi_movi_codi = f.movi_codi
         and f.movi_mone_codi = o.mone_codi(+)
         and f.movi_fech_emis between general_skn.fl_peri_act_ini and
             general_skn.fl_peri_sgt_fin
         and f.movi_fech_emis >= to_date('01/08/2022', 'dd/mm/yyyy')
         and f.movi_codi = fe.elfa_come_mov_cod(+)
         and fe.elfa_come_mov_cod is null
         and (r.remi_codi = p_clave or p_clave is null);
  
    cursor c_detalle(i_clave in number) is
      select to_char(b.deta_prod_codi) codigo,
             b.deta_cant cantidad,
             decode(u.medi_cod_ind_sifen,
                    null,
                    '77',
                    to_char(u.medi_cod_ind_sifen)) unidadmedida,
             rtrim(replace(f.prod_desc, chr(10), ' ')) descripcion,
             b.deta_prec_unit preciounitario,
             (nvl(b.deta_prec_unit, b.deta_impo_mone)) importeitems,
             0 porcentajedescuento,
             0 importedescitems,
             0 totaldescuentoitems,
             0 tasaimpuesto,
             0 gravado10,
             0 iva10,
             0 gravado5,
             0 iva5,
             0 exento,
             0 total,
             a.remi_codi do_clave
        from come_remi      a,
             come_remi_deta b,
             come_sucu      d,
             come_conc      e,
             come_prod      f,
             come_unid_medi u
       where a.remi_codi = b.deta_remi_codi
         and d.sucu_codi = a.remi_sucu_codi
         and e.conc_codi(+) = b.deta_conc_codi
         and f.prod_codi(+) = b.deta_prod_codi
         and u.medi_codi = b.deta_medi_codi
         and a.remi_codi = i_clave;
  
  begin
    v_token := fp_get_token;
    for c in c_remision loop
    
      apex_json.initialize_clob_output;
      apex_json.open_array;
      apex_json.open_object;
      apex_json.write('enviar', 'n');
      apex_json.write('tipoDocElectronico', c.tipodocelectronico);
      apex_json.write('timbrado', c.timbrado, true);
      apex_json.write('fechaIniTimb', c.fechainitimb, true);
      apex_json.write('numeroComprobante', c.numerocomprobante, true);
      apex_json.write('fechaHora', c.fechahora, true);
      apex_json.write('tipoTransaccion', c.tipotransaccion, true);
      apex_json.write('tipoImpuestoAfectado', c.tipoimpuestoafectado, true);
      apex_json.write('tipoOperacion', c.tipooperacion, true);
      apex_json.write('moneda', c.moneda, true);
      apex_json.write('tipoCambio', c.tipocambio, true);
      apex_json.write('tipoReceptor', c.tiporeceptor, true);
      apex_json.write('tipoContribuyenteReceptor',
                      c.tipocontribuyentereceptor,
                      true);
      /* apex_json.write('tipodocumentoreceptor', c.tipodocumentoreceptor,true);*/
      apex_json.write('rucReceptor', c.rucreceptor, true);
      apex_json.write('nombreRazonSocial', c.nombrerazonsocial, true);
      apex_json.write('correoElectronico',
                      c.correoelectronico /*'veramarisa676@gmail.com'*/,
                      true);
      -- apex_json.write('telefono', c.telefono, true);
      apex_json.write('direccion', c.direccion, true);
      apex_json.write('condicionVenta', c.condicionventa, true);
      -- apex_json.write('entregainicial', c.entregainicial, true);
      /*if c.tipodocelectronico not in (5, 6) then
       -- apex_json.write('cuotas', c.cuotas, true);
      end if;
      -- apex_json.write('plazos', c.plazos, true);
      */
    
      apex_json.write('gravada10', c.gravada10, true);
      apex_json.write('iva10', c.iva10, true);
      apex_json.write('gravada5', c.gravada5, true);
      apex_json.write('iva5', c.iva5, true);
      apex_json.write('exento', c.exento, true);
      apex_json.write('totalDescuento', c.totaldescuento, true);
      apex_json.write('total', c.total, true);
      -- apex_json.write('infointeresemisor', c.infointeresemisor, true);
      -- apex_json.write('infointeresfiscal', c.infointeresfiscal, true);
    /*  apex_json.write('codigodepartamentoreceptor',
                      c.codigodepartamentoreceptor,
                      true);
      apex_json.write('departamentoreceptor', c.departamentoreceptor, true);
      apex_json.write('codigodistritorecptor',
                      c.codigodistritorecptor,
                      true);
      apex_json.write('distrito', c.distrito, true);
      apex_json.write('codigociudadreceptor', c.codigociudadreceptor, true);
      apex_json.write('descripcionciudadreceptor',
                      c.descripcionciudadreceptor,
                      true);*/
      -- apex_json.write('celularreceptor', c.celularreceptor, true);
      -- apex_json.write('codigocliente', c.codigocliente, true);
      apex_json.write('codigoPais', c.codigopais);
      -- apex_json.write('numerocasareceptor', c.numerocasareceptor, true);
      -- apex_json.write('nombrefantasiareceptor',c.nombre_fantasia_receptor, true);
    
      --datos correpondiente a las remision
      --
      apex_json.open_object('datosRemision');
      apex_json.write('iMotEmiNR', c.imoteminr, true);
      apex_json.write('iRespEmiNR', c.irespeminr, true);
      --
      apex_json.write('iTipTrans', c.itiptrans, true);
      apex_json.write('iModTrans', c.imodtrans, true);
      apex_json.write('iRespFlete', c.irespflete, true);
      apex_json.write('cCondNeg', c.ccondneg, true);
      apex_json.write('dKmR', 326, true);
    
      --
      apex_json.write('dIniTras', c.dinitras, true);
      apex_json.write('dFinTras', c.dfintras, true);
      apex_json.write('dTiVehTras', nvl(c.dtivehtras, 'Camion'), true);
      apex_json.write('dMarVeh', nvl(c.dmarveh, 'TOYOTA'), true);
      apex_json.write('dTipIdenVeh', c.dtipidenveh, true);
      apex_json.write('dNroIDVeh', c.dnroidveh, true);
      apex_json.write('dNroMatVeh', nvl(c.dnromatveh, 'MGE-123'), true);
      apex_json.write('dNroVuelo', c.dnrovuelo, true);
      apex_json.write('iNatTrans', c.inattrans, true);
      apex_json.write('dNomTrans', nvl(c.dnomtrans, 'MG EXPRESS'), true);
      apex_json.write('dRucTrans', nvl(c.dructrans, '80060064-9'), true);
      apex_json.write('iTipIDTrans', c.itipidtrans, true);
      apex_json.write('dNumIDTrans', c.dnumidtrans, true);
      apex_json.write('cNacTrans', c.cnactrans, true);
      apex_json.write('dDomFisc', c.dDomFisc, true);
      apex_json.write('dNumIDChof', nvl(c.dnumidchof, '80060064-9'), true);
      apex_json.write('dNomChof', nvl(c.dnomchof, 'MG EXPRESS'), true);
      apex_json.write('dDirChof', c.ddirchof, true);
      apex_json.write('dDirLocEnt', c.dDirLocEnt, true);
      apex_json.write('dNumCasEnt', c.dNumCasEnt, true);
      ---prueba de envio
      apex_json.write('cDepEnt', 11, true);
      apex_json.write('dDesDepEnt', 'ALTO PARANA', true);
      --apex_json.write('cDisEnt', '145', true);
      --apex_json.write('dDesDisEnt', 'CIUDAD DEL ESTE', true);
      
      apex_json.write('cCiuEnt', 3383, true);
      apex_json.write('dDesCiuEnt', 'CIUDAD DEL ESTE', true);
    
      apex_json.close_object;
    
      ---**------aca genera el arreglo del detalle---**---
      apex_json.open_array('detalle');
    
      for d in c_detalle(c.remi_codi) loop
      
        apex_json.open_object;
      
        apex_json.write('codigo', d.codigo, true);
        apex_json.write('cantidad', d.cantidad, true);
        apex_json.write('unidadMedida', d.unidadmedida, true);
        apex_json.write('descripcion', d.descripcion, true);
        apex_json.write('precioUnitario', d.preciounitario, true);
        apex_json.write('importeItems', d.importeitems, true);
        apex_json.write('porcentajeDescuento', d.porcentajedescuento, true);
        apex_json.write('importeDescItems', d.importedescitems, true);
        apex_json.write('totalDescuentoItems', d.totaldescuentoitems, true);
        apex_json.write('tasaImpuesto', d.tasaimpuesto, true);
        apex_json.write('gravado10', d.gravado10, true);
        apex_json.write('iva10', d.iva10, true);
        apex_json.write('gravado5', d.gravado5, true);
        apex_json.write('iva5', d.iva5, true);
        apex_json.write('exento', d.exento, true);
        apex_json.write('total', d.total, true);
      
        apex_json.close_object;
      end loop;
    
      apex_json.close_array;
      apex_json.close_object;
      apex_json.close_array;
      v_clob := apex_json.get_clob_output;
      apex_json.free_output;
    
      --**----se hace insert correspondiente------------------------------**-- 
      begin
        select nvl(max(d.elfa_codi), 0) + 1
          into v_codigo
          from come_elec_fact d;
      end;
      begin
        insert into come_elec_fact g
          (g.elfa_codi,
           g.elfa_come_mov_cod,
           elfa_nro_doc,
           elfa_indi_envi,
           elfa_fech_regi,
           
           elfa_fac_env,
           elfa_user_regi,
           elfa_nro_timbrado,
           elfa_tipo_comproban)
        values
          (v_codigo,
           c.doc_clave,
           c.numerocomprobante,
           'P',
           sysdate,
           v_clob,
           fp_user,
           c.timbrado,
           c.tipodocelectronico);
        --**-------------------------------------------------**--
      exception
        when others then
          raise_application_error(-20003,
                                  'Error en tabla COME_ELEC_FACT. ' ||
                                  sqlerrm);
      end;
    end loop;
  
    begin
      -- call the procedure
      env_fact_sifen.pp_set_fact(v_token);
    end;
  end pp_get_json_remision;

  procedure pp_enviar_sms_error(p_tipo in varchar2 default null) is
  
    texto     varchar2(5000);
    remitente varchar2(500);
    respuesta varchar2(500);
    b         varchar2(5000);
  
    v_ensm_codi           number;
    v_descripcion         varchar2(200);
    v_ensm_clpr_desc      varchar2(200);
    v_ensm_clpr_tele      varchar2(200);
    v_ensm_clpr_codi      number;
    v_ensm_clpr_codi_alte number;
  begin
  
    select smco_text, smco_desc
      into texto, v_descripcion
      from come_envi_sms_conf
     where smco_codi = 17;
    --  fecha := sysdate;
    b         := replace(texto || '-' || p_tipo, sysdate);
    remitente := fa_busc_para('P_SMS_CONF_NUME_FROM');
  
    ---------------ticket nro #755
    pp_send_email(v_to      => 'tecnologia3@alarmas.com.py',
                  v_to_copy => null,
                  v_asunto  => 'SIFEN',
                  v_mensaje => b);
  
    /* begin
      pack_incl_excl_infor.pp_enviar_sms(p_cuerpo       => b,
                                         p_destinatario => '+595983806362', --tel,
                                         p_remitente    => remitente,
                                         response       => respuesta);
    end;
    
    
    ------------------------lv 01/03/2023       
    
                      
             select t.clpr_desc, t.clpr_tele, clpr_codi, t.clpr_codi_alte
               into v_ensm_clpr_desc, v_ensm_clpr_tele,v_ensm_clpr_codi,v_ensm_clpr_codi_alte
             from come_clie_prov t
             where clpr_codi = 10062238301;
    
              v_ensm_codi           := sec_come_envi_sms.nextval;
    
    
              insert into come_envi_sms
                (ensm_codi,
                 ensm_fech_envi,
                 ensm_user_envi,
                 ensm_clpr_codi,
                 ensm_clpr_tele,
                 ensm_text,
                 ensm_tipo,
                 ensm_indi_envi,
                 ensm_fech_regi,
                 ensm_tipo_desc,
                 ensm_clpr_desc,
                 ensm_clpr_codi_alte,
                 ensm_smco_codi)
              values
                (v_ensm_codi,
                 sysdate,
                 'ALARMAS',
                 v_ensm_clpr_codi,
                 v_ensm_clpr_tele,
                 texto,
                 'A',
                 'N',
                 sysdate,
                 v_descripcion,
                 v_ensm_clpr_desc,
                 v_ensm_clpr_codi_alte,
                 17);*/
    begin
      /* pack_incl_excl_infor.pp_enviar_sms(p_cuerpo       => b,
      p_destinatario => '+595981813719',--tel,
      p_remitente    => remitente,
      response       => respuesta);*/
      null;
    end;
  
  end pp_enviar_sms_error;

  procedure pp_envi_fact_mens is
    v_asunto  varchar2(200);
    v_mensaje clob;
    v_html    clob;
    v_file    clob;
    content   varchar2(4000);
    content2  varchar2(4000);
    content3  varchar2(4000);
  
    req          utl_http.req;
    res          utl_http.resp;
    url          varchar2(4000) := 'https://api.postmarkapp.com/email';
    archivo      clob;
    v_req_length number;
    buffer       varchar2(4000);
    offset       number := 1;
    amount       number := 1024;
    v_enfa_codi  number;
    codi         number;
  
    cursor facturas is
      select movi_codi, email, cliente
        from (select distinct (movi_codi) movi_codi,
                              case
                                when clpr_email is not null and
                                     clpr_email_fact is null then
                                 case
                                   when lengthb(clpr_email) <= 8 then
                                    null
                                   else
                                    ltrim(rtrim(clpr_email))
                                 end
                                when clpr_email is null and
                                     clpr_email_fact is not null then
                                 case
                                   when lengthb(clpr_email_fact) <= 8 then
                                    null
                                   else
                                    ltrim(rtrim(clpr_email_fact))
                                 end
                                when clpr_email is not null and
                                     clpr_email_fact is not null then
                                 case
                                   when lengthb(clpr_email_fact) <= 8 then
                                    null
                                   when clpr_email_fact like '%;%' then
                                    null
                                   else
                                    ltrim(rtrim(clpr_email_fact))
                                 end
                                else
                                 null
                              end email,
                              
                              clpr_codi cliente
                from come_movi, come_elec_fact, come_clie_prov
               where movi_timo_codi in (2)
                 and movi_fech_emis = trunc(sysdate, 'mm')
                 and movi_codi = elfa_come_mov_cod
                 and clpr_codi = movi_clpr_codi
                 and movi_codi not in
                     (select distinct (t.enfa_movi_codi)
                        from come_envi_fact t
                       where t.enfa_indi_envi = 'S'
                         and trunc(t.enfa_fech_regi) = trunc(sysdate, 'mm')))
       where email is not null;
  
  begin
  
    begin
    
      select faco_asunto, dbms_lob.substr(faco_mensaje, 4000, 1), faco_html
        into v_asunto, v_mensaje, v_html
        from come_envi_fact_conf
       where faco_codi = 1;
    
    exception
      when others then
        v_asunto  := 'Factura disponible';
        v_mensaje := 'LA FACTURA DE ESTE MES YA ESTA DISPONIBLE';
      
    end;
  
    for x in facturas loop
      buffer := '';
      offset := 1;
    
      env_fact_sifen.pp_reto_envi_fact(x.movi_codi, v_file);
    
      --'||x.email||'
      content := '{
                        "from": "cobranzas@alarmas.com.py",
                        "to": "' || x.email || '",
                        "subject": "' || v_asunto || '",
                        "tag": "facturacion",
                        "textbody": "' || v_mensaje || '",
                        "htmlbody": "<html><body>';
    
      content2 := '</body></html>",
                        "trackopens": true,
                        "tracklinks": "htmlandtext",
                        "attachments": [
                          {
                            "name": "factura.pdf",
                            "content": "';
    
      content3 := '",
                            "contenttype": "application/octet-stream"
                          }
                        ]
                      }';
    
      codi    := x.movi_codi;
      archivo := content || v_html || content2 || v_file || content3;
    
      v_req_length := 0;
      if archivo is not null then
      
        v_req_length := dbms_lob.getlength(archivo);
      
        utl_http.set_wallet('file:/oracle/wallet', null);
      
        req := utl_http.begin_request(url, 'POST', 'HTTP/1.1');
        utl_http.set_header(req, 'user-agent', 'mozilla/4.0');
        utl_http.set_header(req, 'content-type', 'application/json');
        utl_http.set_header(req, 'Content-Length', v_req_length);
        utl_http.set_header(req, 'Accept', 'application/json');
        utl_http.set_header(req,
                            'X-Postmark-Server-Token',
                            '374393af-865a-477c-9018-5c3ac3c928b1');
        utl_http.set_header(req, 'Transfer-Encoding', 'Chunked');
      
        while (offset < v_req_length) loop
          dbms_lob.read(archivo, amount, offset, buffer);
          utl_http.write_text(r => req, data => buffer);
          offset := offset + amount;
        end loop;
      
        res := utl_http.get_response(req);
      
        select nvl(max(enfa_codi), 0) + 10
          into v_enfa_codi
          from come_envi_fact;
      
        insert into come_envi_fact
          (enfa_codi,
           enfa_movi_codi,
           enfa_clpr_codi,
           enfa_clpr_email,
           enfa_asunto,
           enfa_mensaje,
           enfa_fech_regi,
           enfa_respuesta,
           enfa_indi_envi,
           enfa_user_regi,
           enfa_json_envi)
        values
          (v_enfa_codi,
           x.movi_codi,
           x.cliente,
           x.email,
           v_asunto,
           v_mensaje,
           sysdate,
           null,
           'S',
           fp_user,
           archivo);
      
        begin
          if res.status_code = 200 then
          
            loop
              utl_http.read_line(res, buffer);
              begin
              
                update come_envi_fact
                   set enfa_respuesta = nvl(enfa_respuesta, '') || buffer,
                       enfa_indi_envi = 'S'
                 where enfa_codi = v_enfa_codi;
              
              exception
                when others then
                  raise_application_error(-20004,
                                          'Error al cargar registro de Envios' ||
                                          sqlerrm);
              end;
            end loop;
          
          else
          
            loop
              utl_http.read_line(res, buffer);
              begin
                update come_envi_fact
                   set enfa_respuesta = buffer, enfa_indi_envi = 'N'
                 where enfa_codi = v_enfa_codi;
              
              exception
                when others then
                  raise_application_error(-20005,
                                          'No se ha enviado el correo');
              end;
            end loop;
          
          end if;
          utl_http.end_response(res);
        
        exception
          when utl_http.end_of_body then
            utl_http.end_response(res);
        end;
      
      end if;
    
    end loop;
  
  exception
    when others then
      declare
        remitente varchar2(5000);
        respuesta varchar2(5000);
      begin
        remitente := fa_busc_para('P_SMS_CONF_NUME_FROM');
      
        pp_send_email(v_to      => 'tecnologia3@alarmas.com.py',
                      v_to_copy => null,
                      v_asunto  => 'SIFEN',
                      v_mensaje => sqlerrm || ' ENVIO FACT MENS SIFEN ' || codi);
      
      end;
  end pp_envi_fact_mens;

  procedure pp_envi_fact_vent(p_codi in number) is
  
    v_asunto  varchar2(200);
    v_mensaje clob;
    v_html    clob;
    v_file    clob;
    content   clob;
    content2  clob;
    content3  clob;
  
    req          utl_http.req;
    res          utl_http.resp;
    url          varchar2(4000) := 'https://api.postmarkapp.com/email';
    archivo      clob;
    v_req_length number;
    buffer       varchar2(4000);
    offset       number := 1;
    amount       number := 1024;
    v_enfa_codi  number;
  
    c_email varchar2(500);
    c_codi  number;
  
  begin
  
    select clpr_email email, clpr_codi cliente
      into c_email, c_codi
      from come_movi, come_clie_prov cf
     where movi_codi = p_codi
       and clpr_codi = movi_clpr_codi;
  
    begin
    
      select faco_asunto, dbms_lob.substr(faco_mensaje, 4000, 1) --, faco_html
        into v_asunto, v_mensaje --, v_html
        from come_envi_fact_conf
       where faco_codi = 5;
    
    exception
      when others then
        v_asunto  := 'Factura disponible';
        v_mensaje := 'SU FACTURA';
      
    end;
  
    begin
    
      env_fact_sifen.pp_reto_envi_fact(to_char(p_codi), v_file);
    
      /* env_fact_sifen.pp_reto_envi_fact(p_movi_codi => to_char(p_codi),
      p_file => v_file);*/
    end;
  
    v_html := '<div style=''text-align: center;background-color: #ff6b00''><img align=''center'' alt='''' class=''mcnImage'' src=''https://gallery.mailchimp.com/a66e4b7bd8f3e3399ebae096a/images/6ef009e5-4010-450c-af54-d22809cac1e7.png'' style=''max-width: 1024px; padding-bottom: 0px; vertical-align: bottom; display: inline !important; border-radius: 0%;'' width=''120'' /></div>
             <div style=''text-align: center;''><img alt='''' src=''https://mcusercontent.com/a66e4b7bd8f3e3399ebae096a/images/1545690c-4894-471a-847d-19dd53a0416c.jpg'' style=''max-width: 500px; border: 1px none; border-radius: 0%;'' width=''500'' /></div>
             <div style=''text-align: center;''><strong>SU FACTURA</strong><br />
                <br /></div>
             <div style=''text-align: center;''>&iquest;Alguna duda? Escribinos a&nbsp;<br />
             <strong>cobranzas@alarmas.com.py</strong></div>';
  
    content := '{
                        "from": "cobranzas@alarmas.com.py",
                        "to": "' || c_email || '",
                        "subject": "' || v_asunto || '",
                        "tag": "facturacion",
                        "textbody": "' || v_mensaje || '",
                        "htmlbody": "<html><body>';
  
    content2 := '</body></html>",
                        "trackopens": true,
                        "tracklinks": "htmlandtext",
                        "messagestream": "outbound",
                        "attachments": [
                          {
                            "name": "factura.pdf",
                            "content": "';
  
    content3 := '",
                            "contenttype": "application/octet-stream"
                          }
                        ]
                      }';
  
    archivo := content || v_html || content2 || v_file || content3;
  
    if archivo is not null then
    
      v_req_length := dbms_lob.getlength(archivo);
    
      utl_http.set_wallet('file:/oracle/wallet', null);
      req := utl_http.begin_request(url, 'POST', 'HTTP/1.1');
      utl_http.set_header(req, 'user-agent', 'mozilla/4.0');
      utl_http.set_header(req, 'Accept', 'application/json');
      utl_http.set_header(req, 'content-type', 'application/json');
      utl_http.set_header(req, 'Content-Length', v_req_length);
      utl_http.set_header(req,
                          'X-Postmark-Server-Token',
                          '374393af-865a-477c-9018-5c3ac3c928b1');
      utl_http.set_header(req, 'Transfer-Encoding', 'Chunked');
    
      while (offset < v_req_length) loop
        dbms_lob.read(archivo, amount, offset, buffer);
        utl_http.write_text(r => req, data => buffer);
        offset := offset + amount;
      
      end loop;
    
      res := utl_http.get_response(req);
    
      select nvl(max(enfa_codi), 0) + 1
        into v_enfa_codi
        from come_envi_fact;
    
      insert into come_envi_fact
        (enfa_codi,
         enfa_movi_codi,
         enfa_clpr_codi,
         enfa_clpr_email,
         enfa_asunto,
         enfa_mensaje,
         enfa_fech_regi,
         enfa_respuesta,
         enfa_indi_envi,
         enfa_user_regi)
      values
        (v_enfa_codi,
         p_codi,
         c_codi,
         c_email,
         v_asunto,
         v_mensaje,
         sysdate,
         null,
         'S',
         fp_user);
    
      begin
        if res.status_code = 200 then
        
          loop
            utl_http.read_line(res, buffer);
            begin
            
              update come_envi_fact
                 set enfa_respuesta = nvl(enfa_respuesta, '') || buffer
               where enfa_codi = v_enfa_codi;
            
            exception
              when others then
                raise_application_error(-20004,
                                        'Error al cargar registro de Envios' ||
                                        sqlerrm);
            end;
          end loop;
        
        elsif res.status_code = 404 then
        
          null;
        
        else
        
          loop
            utl_http.read_line(res, buffer);
            begin
              update come_envi_fact
                 set enfa_respuesta = buffer
               where enfa_codi = v_enfa_codi;
            
            exception
              when others then
                raise_application_error(-20005,
                                        'No se ha enviado el correo');
            end;
          end loop;
        
        end if;
        utl_http.end_response(res);
      
      exception
        when utl_http.end_of_body then
          utl_http.end_response(res);
      end;
    
    end if;
  
  exception
    when others then
      null;
      declare
        remitente varchar2(5000);
        respuesta varchar2(5000);
      begin
        remitente := fa_busc_para('P_SMS_CONF_NUME_FROM');
        pp_send_email(v_to      => 'tecnologia3@alarmas.com.py',
                      v_to_copy => null,
                      v_asunto  => 'SIFEN',
                      v_mensaje => sqlerrm || ' Vent. Ventanilla ' || p_codi);
      
      end;
    
  end pp_envi_fact_vent;

  procedure pp_reto_envi_fact(p_movi_codi in varchar2, p_file out clob) is
  
    v_blob          blob;
    v_hostname      varchar2(30) := '168.138.147.91';
    v_port          number := '8080';
    v_username      varchar2(50) := 'jasperadmin';
    v_password      varchar2(50) := 'jaalar$2024';
    v_jasper_string varchar2(30) := v_username || ';' || v_password;
    v_login_url     varchar2(100) := 'http://' || v_hostname || ':' ||
                                     v_port || '/jasperserver/rest/login';
    formato         varchar2(20) := 'pdf';
    nombre_reporte  varchar2(200) := 'factura';
    v_report_url    varchar2(100);
    v_codigo        varchar2(100);
  
  begin
  
    v_codigo     := p_movi_codi;
    v_report_url := 'http://' || v_hostname || ':' || v_port ||
                    '/jasperserver/rest_v2/reports/Reports/' ||
                    nombre_reporte || '.' || formato;
  
    -- nos logeamos al servidor de jasperserver
    v_blob := apex_web_service.make_rest_request_b(p_url         => v_login_url,
                                                   p_http_method => 'GET',
                                                   p_parm_name   => apex_util.string_to_table('j_username;j_password',
                                                                                              ';'),
                                                   p_parm_value  => apex_util.string_to_table(v_jasper_string,
                                                                                              ';'));
  
    -- descargarmos el archivo
    v_blob := apex_web_service.make_rest_request_b(p_url         => v_report_url,
                                                   p_http_method => 'GET',
                                                   p_parm_name   => apex_util.string_to_table('p_movi_codi'),
                                                   p_parm_value  => apex_util.string_to_table(v_codigo));
  
    /*owa_util.mime_header('application/octet', true); -- para descargar el reporte
    htp.p('content-length: ' || dbms_lob.getlength(v_blob));
    htp.p('content-disposition: ' || v_vccontentdisposition || '; filename="' || nombre_reporte || '"');
    owa_util.http_header_close;
    wpg_docload.download_file(v_blob);*/
    --apex_application.stop_apex_engine;
    p_file := base64encode(v_blob);
  
  end pp_reto_envi_fact;

  procedure pp_reenviar_fact_rech(p_movi_codi in number) is
  
  begin
  
    delete come_elec_fact a where a.elfa_come_mov_cod = p_movi_codi;
  
    env_fact_sifen.pp_get_json_fact(p_movi_codi);
  
  end pp_reenviar_fact_rech;
  
  
  
 procedure PP_INUTILIZAR_NRO_DOC(p_movi_codi in number) is
    REQ       UTL_HTTP.REQ;
    RES       UTL_HTTP.RESP;
    URL       VARCHAR2(4000) := 'http://test.kigafe.com:8444/dpy-prodfe/rest/comprobantes/inutilizar';
    BUFFER    VARCHAR2(32767);
    V_CONTENT VARCHAR2(32767);
    V_RETURN  CLOB;
    V_TOKEN   VARCHAR2(200);
    V_ESTADO  VARCHAR(50);
    V_ERROR   VARCHAR2(300);
  
    CURSOR C_ANUL IS
   select t.elfa_codi,
       t.elfa_nro_doc,
       t.elfa_nro_control,
       t.elfa_user_regi,
       t.elfa_fech_regi,
       t.elfa_indi_envi,
       t.elfa_qr,
       t.elfa_estado,
       t.elfa_desc_resul,
       t.elfa_nro_lote,
       t.elfa_come_mov_cod,

       t.elfa_nro_timbrado,
       t.elfa_tipo_comproban,
       t.elfa_timo_codi
     

from come_elec_fact t
where elfa_timo_codi = 9
 and t.elfa_come_mov_cod=p_movi_codi;
  
  BEGIN
    V_TOKEN :=env_fact_sifen.FP_GET_TOKEN;
  
    FOR I IN C_ANUL  LOOP
    
      APEX_JSON.INITIALIZE_CLOB_OUTPUT;
      APEX_JSON.OPEN_ARRAY;
      APEX_JSON.OPEN_OBJECT;
      APEX_JSON.WRITE('timbrado','15734738', TRUE);
    
      APEX_JSON.WRITE('tipoDocElectronico',i.elfa_tipo_comproban , TRUE);
      APEX_JSON.WRITE('numeroComprobante',i.elfa_nro_doc, TRUE);
      APEX_JSON.CLOSE_OBJECT;
      APEX_JSON.CLOSE_ARRAY;
      
   
      V_CONTENT := APEX_JSON.GET_CLOB_OUTPUT;
      APEX_JSON.FREE_OUTPUT;
    
      SYS.UTL_HTTP.SET_WALLET('file:/oracle/wallet', 'Alarmas2022');
      REQ := UTL_HTTP.BEGIN_REQUEST(URL, 'POST', 'HTTP/1.1');
      UTL_HTTP.SET_HEADER(REQ, 'User-Agent', 'Mozilla/4.0');
      UTL_HTTP.SET_HEADER(REQ, 'Content-Type', 'application/json');
      UTL_HTTP.SET_HEADER(REQ, 'Content-Length', LENGTH(V_CONTENT));
      UTL_HTTP.SET_HEADER(REQ, 'Authorization', 'Bearer ' || V_TOKEN);
      --UTL_HTTP.SET_TRANSFER_TIMEOUT(REQ,70);
      UTL_HTTP.WRITE_TEXT(REQ, V_CONTENT);
    
      RES := UTL_HTTP.GET_RESPONSE(REQ);
      BEGIN
        LOOP
          UTL_HTTP.READ_TEXT(RES, BUFFER);
          V_RETURN := V_RETURN || BUFFER;
        END LOOP;
      
        UTL_HTTP.END_RESPONSE(RES);
      
      EXCEPTION
        WHEN UTL_HTTP.END_OF_BODY THEN
          UTL_HTTP.END_RESPONSE(RES);
        WHEN OTHERS THEN
          DBMS_OUTPUT.PUT_LINE('Error ' || SQLERRM);
      END;
    
      SELECT JSON_VALUE(V_RETURN, '$.estado') INTO V_ESTADO FROM DUAL;
   
    
      IF RES.STATUS_CODE = 200 THEN
      
        BEGIN
          UPDATE COME_ELEC_FACT
             SET ELFA_ESTADO    = V_ESTADO,
                 ELFA_INDI_ENVI = SUBSTR(V_ESTADO, 1, 1)
           WHERE ELFA_CODI = I.ELFA_CODI
            and elfa_tipo_comproban=I.elfa_tipo_comproban
            and elfa_nro_doc=I.elfa_nro_doc
            AND ELFA_COME_MOV_COD = I.ELFA_COME_MOV_COD;
        
        EXCEPTION
          WHEN OTHERS THEN
           /* RAISE_APPLICATION_ERROR(-20004,
                                    'Error al actualizar en la tabla de envio de facturas ' ||
                                    SQLERRM);
      */null;
        END;
      
        COMMIT;
      END IF;
    
   end loop;
  EXCEPTION
    WHEN OTHERS THEN
      V_eRROR := SQLERRM;
      insert into sifen_error_log
        (logs_fech, logs_user, logs_proc, logs_error_mens)
      values
        (sysdate,fp_user, 'PP_INUTILIZAR_NRO_DOC', V_eRROR);
   
  
end PP_INUTILIZAR_NRO_DOC;

  
  

end env_fact_sifen;
