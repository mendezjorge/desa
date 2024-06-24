
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I020014" is
 
  v_erro_codi           number;
  v_erro_desc           varchar2(5000);
 
  salir                 exception;
 
  p_clpr_indi_clie_prov varchar2(5000):= 'C';
  p_cheq_tipo           varchar2(5000):= 'R';
  p_codi_base           varchar2(5000):= pack_repl.fa_devu_codi_base;
  p_codi_timo_extr_banc varchar2(5000):= to_number(fa_busc_para ('p_codi_timo_extr_banc'));
  p_codi_mone_mmee      varchar2(5000):= to_number(fa_busc_para ('p_codi_mone_mmee'));
  p_cant_deci_mmee      varchar2(5000):= to_number(fa_busc_para ('p_cant_deci_mmee'));
  p_codi_conc_extr_mone varchar2(5000):= to_number(fa_busc_para ('p_codi_conc_extr_mone'));
  p_codi_impu_exen      varchar2(5000):= to_number(fa_busc_para ('p_codi_impu_exen')); 
  p_codi_conc           varchar2(5000):= to_number(fa_busc_para ('p_codi_conc_cheq_cred')); 
  p_fech_fini           date;
  p_fech_inic           date;
  
/***************** ACTUALIZAR REGISTROS ********/
 procedure pp_actu_regi(i_cheq_cuen_codi in come_cheq.cheq_cuen_codi%type,
                        i_cheq_clpr_codi in come_cheq.cheq_clpr_codi%type,
                        i_cheq_nume      in come_cheq.cheq_nume%type,
                        i_cheq_serie     in come_cheq.cheq_serie%type,
                        i_cheq_nume_cuen in come_cheq.cheq_nume_cuen%type,
                        i_cheq_banc_codi in come_cheq.cheq_banc_codi%type,
                        i_cheq_tasa_mone in come_cheq.cheq_tasa_mone%type,
                        i_cheq_fech_emis in come_cheq.cheq_fech_emis%type,
                        i_cheq_fech_venc in come_cheq.cheq_fech_venc%type,
                        i_cheq_impo_mmnn in come_cheq.cheq_impo_mmnn%type,
                        i_cheq_impo_mone in come_cheq.cheq_impo_mone%type,                     
                        i_cheq_clpr_desc in come_clie_prov.clpr_desc%type,
                        i_cheq_obse      in come_cheq.cheq_obse%type,
                        i_cheq_mone_codi in come_cheq.cheq_mone_codi%type,
                        i_cheq_titu      in come_cheq.cheq_titu%type,
                        i_cheq_indi_terc in come_cheq.cheq_indi_terc%type,
                        i_sucu_codi      in number,
                        i_empr_codi      in number,
                        i_cheq_fech_oper in date,
                        i_cant_deci      in number) is

    v_movi_codi                       number;
    v_movi_timo_codi                  number;
    v_movi_clpr_codi                  number;
    v_movi_sucu_codi_orig             number;
    v_movi_cuen_codi                  number;
    v_movi_mone_codi                  number;
    v_movi_nume                       number;
    v_movi_fech_emis                  date;
    v_movi_fech_grab                  date;
    v_movi_fech_oper                  date;
    v_movi_user                       char(20);
    v_movi_codi_padr                  number;
    v_movi_tasa_mone                  number;
    v_movi_tasa_mmee                  number;
    v_movi_grav_mmnn                  number;
    v_movi_exen_mmnn                  number;
    v_movi_iva_mmnn                   number;
    v_movi_grav_mmee                  number;
    v_movi_exen_mmee                  number;
    v_movi_iva_mmee                   number;
    v_movi_grav_mone                  number;
    v_movi_exen_mone                  number;
    v_movi_iva_mone                   number;
    v_movi_clpr_desc                  char(80);
    v_movi_emit_reci                  char(1);
    v_movi_afec_sald                  char(1);
    v_movi_dbcr                       char(1);
    v_movi_empr_codi                  number;
    v_movi_obse                       varchar2(80);
    v_tica_codi                       number;  


    --variables para moco
    v_moco_movi_codi number;
    v_moco_nume_item number;
    v_moco_conc_codi number;
    v_moco_cuco_codi number;
    v_moco_impu_codi number;
    v_moco_impo_mmnn number;
    v_moco_impo_mmee number;
    v_moco_impo_mone number;
    v_moco_dbcr   char(1);


    --variables para moimpo 
    v_moim_movi_codi  number;
    v_moim_nume_item  number := 0;
    v_moim_tipo       char(20);
    v_moim_cuen_codi  number;
    v_moim_dbcr       char(1);
    v_moim_afec_caja  char(1);
    v_moim_fech       date;
    v_moim_fech_oper  date;
    v_moim_impo_mone  number;
    v_moim_impo_mmnn  number;
    v_moim_cheq_codi  number;


    v_cheq_codi               number      ;
    v_cheq_mone_codi          number      ;
    v_cheq_banc_codi          number      ;
    v_cheq_nume               number      ;
    v_cheq_nume_cuen          varchar2(20);
    v_cheq_serie              varchar2(3) ;
    v_cheq_fech_emis          date        ;
    v_cheq_fech_venc          date        ;
    v_cheq_impo_mone          number      ;
    v_cheq_impo_mmnn          number      ;
    v_cheq_tipo               varchar2(1) ;
    v_cheq_clpr_codi          number      ;
    v_cheq_esta               varchar2(1) ;
    v_cheq_orde               varchar2(60);
    v_cheq_tasa_mone          number;
    v_cheq_fech_grab          date;
    v_cheq_user               varchar2(10);
    v_cheq_cuen_codi          number;
    v_cheq_indi_ingr_manu     varchar2(1):= 'N';
    v_cheq_titu               varchar2(60);

    v_chmo_movi_codi          number;
    v_chmo_cheq_codi          number;
    v_chmo_esta_ante          char(1);
    v_chmo_cheq_secu          number;
    v_cheq_indi_terc          varchar2(1);

    v_chmo_cheq_esta          varchar2(1);
    v_chmo_asie_codi          number;



begin
 
---revalidar datos a ingresar
    if i_cheq_banc_codi is null then
     raise_application_error(-20001,'Debe ingresar La Entidad Bancaria.');
     end if;
     
    if i_cheq_serie is null then
     raise_application_error(-20001,'Debe ingresar la Serie del Cheque.');
     end if;
     
      if i_cheq_nume is null then
     raise_application_error(-20001,'Debe ingresar el Numero del cheque.');
     end if;
     
      
      if i_cheq_clpr_codi is null then
      raise_application_error(-20001,'Debe ingresar el codigo del cliente.');
      end if;
        if i_CHEQ_CUEN_CODI is null then
      raise_application_error(-20001,'Debe ingresar la Caja.');
      end if;
      
      
     
      if i_cheq_impo_mone is null or i_cheq_impo_mone<=0 then
     raise_application_error(-20001, 'El importe del cheque debe ser mayor a cero.');
     end if;
     
     
     begin	
	
  select cheq_codi, nvl(cheq_indi_ingr_manu, 'N'), cheq_esta 
  into v_cheq_codi, v_cheq_indi_ingr_manu        , v_cheq_esta
  from come_cheq
  where cheq_serie    = i_cheq_serie
  and cheq_banc_codi  = i_cheq_banc_codi
  and cheq_nume       = i_cheq_nume
  and cheq_tipo       = v('P38_CHEQ_TIPO');
   
   raise_application_error(-20001,'Nro. de cheque existente!');
   
Exception
   When no_data_found then      
     null;  
end;
-------------- 
 ---insertar el movimiento de salida (origen) (extraccion)
   -- pp_muestra_tipo_movi
     begin
       
      select timo_afec_sald, timo_emit_reci, timo_dbcr, timo_tica_codi
        into v_movi_afec_sald, v_movi_emit_reci, v_movi_dbcr, v_tica_codi
        from come_tipo_movi
       where timo_codi = p_codi_timo_extr_banc;

      exception
        when no_data_found then
         RAISE_APPLICATION_ERROR( -20010, 'Tipo de Movimiento inexistente');
        when too_many_rows then
         RAISE_APPLICATION_ERROR( -20010, 'Tipo de Movimiento Duplicado');
        when others then
          RAISE_APPLICATION_ERROR( -20010, 'Error al momento de mostrar TM: '||sqlcode);
     
      end;

  
  v_movi_codi_padr                   := null;
  v_movi_codi                        := fa_sec_come_movi;
  v_movi_timo_codi                   := to_number(p_codi_timo_extr_banc);
  v_movi_cuen_codi                   := i_cheq_cuen_codi;
  v_movi_clpr_codi                   := i_cheq_clpr_codi;
  v_movi_sucu_codi_orig              := i_sucu_codi;
  v_movi_mone_codi                   := i_cheq_mone_codi;
  v_movi_nume                        := i_cheq_nume;
  v_movi_fech_emis                   := nvl(i_cheq_fech_emis,sysdate);
  v_movi_fech_grab                   := sysdate;
  v_movi_fech_oper                   := nvl(i_cheq_fech_oper,sysdate);
  v_movi_user                        := gen_user; 
  v_movi_tasa_mone                   := i_cheq_tasa_mone;
  
  --busca la tasa de la moneda extranjera para la fecha de la operacion
  --pp_busca_tasa_mone                (p_codi_mone_mmee, i_cheq_fech_emis, v_movi_tasa_mmee, v_tica_codi);
  begin
    
   if i_cheq_mone_codi = 1 then
    v_movi_tasa_mmee := 1;
  else
    select coti_tasa
      into v_movi_tasa_mmee
      from come_coti
     where coti_mone = i_cheq_mone_codi
       and coti_fech = i_cheq_fech_emis
       and coti_tica_codi = v_tica_codi;
  end if;

exception
  when no_data_found then
    v_movi_tasa_mmee := null;
  when too_many_rows then
    raise_application_error(-20010, 'Tasa Duplicada');
  when others then
    raise_application_error(-20010, 'Error al buscar la tasa: '||sqlcode);
 end; 
  
  
  v_movi_grav_mmnn                   := 0;
  v_movi_exen_mmnn                   := i_cheq_impo_mmnn;
  v_movi_iva_mmnn                    := 0;
  v_movi_grav_mmee                   := 0;
  v_movi_exen_mmee                   := round (i_cheq_impo_mmnn/v_movi_tasa_mmee, p_cant_deci_mmee);
  v_movi_iva_mmee                    := 0;
  v_movi_grav_mone                   := 0;
  v_movi_exen_mone                   := i_cheq_impo_mone;
  v_movi_iva_mone                    := 0;
  v_movi_clpr_desc                   := i_cheq_clpr_desc;                     
  v_movi_empr_codi                   := i_empr_codi; 
  v_movi_obse                        := i_cheq_obse;

  begin 
  
   i020014.pp_inse_come_movi(v_movi_codi,
                              v_movi_timo_codi,
                              v_movi_cuen_codi,
                              v_movi_clpr_codi,                   
                              v_movi_sucu_codi_orig,              
                              v_movi_mone_codi,                   
                              v_movi_nume,                        
                              v_movi_fech_emis,                   
                              v_movi_fech_grab,                   
                              v_movi_fech_oper,                   
                              v_movi_user,                        
                              v_movi_codi_padr,                   
                              v_movi_tasa_mone,                   
                              v_movi_tasa_mmee,                   
                              v_movi_grav_mmnn,                   
                              v_movi_exen_mmnn,                   
                              v_movi_iva_mmnn,                    
                              v_movi_grav_mmee,                   
                              v_movi_exen_mmee,                   
                              v_movi_iva_mmee,                   
                              v_movi_grav_mone,                   
                              v_movi_exen_mone,                   
                              v_movi_iva_mone,                    
                              v_movi_clpr_desc,                   
                              v_movi_emit_reci,                   
                              v_movi_afec_sald,                   
                              v_movi_dbcr,                        
                              v_movi_empr_codi,                    
                              v_movi_obse);
           
  exception 
    when others then 
      raise_application_error(-20010, 'Error al momento de querer insertar come_movi: '||sqlcode);
  end;

 ----actualizar moco.... 
  v_moco_movi_codi := v_movi_codi;
  v_moco_nume_item := 0;
  v_moco_conc_codi := p_codi_conc;
  v_moco_dbcr      := 'C';
  v_moco_nume_item := v_moco_nume_item + 1;       
  v_moco_cuco_codi := null;
  v_moco_impu_codi := p_codi_impu_exen;
  v_moco_impo_mmnn := v_movi_exen_mmnn;
  v_moco_impo_mmee := 0;
  v_moco_impo_mone := v_movi_exen_mone;
 
 begin
        
  i020014.pp_inse_movi_conc_deta(v_moco_movi_codi ,
                                 v_moco_nume_item ,
                                 v_moco_conc_codi ,
                                 v_moco_cuco_codi ,
                                 v_moco_impu_codi ,
                                 v_moco_impo_mmnn ,
                                 v_moco_impo_mmee ,
                                 v_moco_impo_mone ,
                                 v_moco_dbcr);  
 exception 
   when others then 
     raise_application_error(-20010, 'Error al insertar en concepto Deta: '||sqlcode);
 end;           
 
  --actualizar moim...
 begin
   
  i020014.pp_inse_come_movi_impu_deta (to_number(p_codi_impu_exen), 
                                       v_movi_codi, 
                                       v_movi_exen_mmnn,
                                       0,
                                       0,
                                       0,
                                       v_movi_exen_mone,
                                       0);    
 exception 
   when others then 
     raise_application_error(-20010, 'Error al insertar en impuestos Deta: '||sqlcode);
 end;    

   --insert come_cheq y cheq_movi 
          v_cheq_tipo               := 'R'; --Recibido       
          v_cheq_clpr_codi          := i_cheq_clpr_codi;         
          v_cheq_esta               := 'I'; --ingresado             
          v_cheq_user               := substr(gen_user,1,10);
          v_cheq_fech_grab          := sysdate;
          v_chmo_movi_codi          := v_movi_codi;
          v_cheq_indi_ingr_manu     := 'N'; --Ingresado Manualmente      
          
         
          
            v_cheq_cuen_codi          := i_cheq_cuen_codi;       
            v_cheq_mone_codi          := i_cheq_mone_codi;  
            v_cheq_tasa_mone          := i_cheq_tasa_mone;
            v_cheq_codi               := fa_sec_come_cheq;          
            v_cheq_nume               := i_cheq_nume;  
            v_cheq_serie              := i_cheq_serie;  
            v_cheq_nume_cuen          := i_cheq_nume_cuen;               
            v_cheq_banc_codi          := i_cheq_banc_codi;       
            v_cheq_fech_emis          := i_cheq_fech_emis;  
            v_cheq_fech_venc          := nvl(i_cheq_fech_venc,sysdate);    
            v_cheq_impo_mone          := i_cheq_impo_mone;  
            v_cheq_impo_mmnn          := round((i_cheq_impo_mone* i_cheq_tasa_mone), i_cant_deci);              
            v_cheq_tasa_mone          := i_cheq_tasa_mone;  
            
            
            v_chmo_cheq_codi          := v_cheq_codi;
            v_chmo_esta_ante          := null; --pq no tiene estado anterior..., o sea es el primier mov. dl chque
            v_chmo_cheq_secu          := 1; --tendra la secuencia 1 pq es el movimiento q dio origen al cheque...
            v_cheq_titu               := i_cheq_titu;
            v_cheq_indi_terc          := i_cheq_indi_terc;

 begin
     i020014.pp_inse_come_cheq( v_cheq_codi,
                                v_cheq_mone_codi,     
                                v_cheq_banc_codi,     
                                v_cheq_nume,          
                                v_cheq_serie,         
                                v_cheq_fech_emis,     
                                v_cheq_fech_venc,     
                                v_cheq_impo_mone,     
                                v_cheq_impo_mmnn,     
                                v_cheq_tipo,          
                                v_cheq_clpr_codi,     
                                v_cheq_esta,          
                                v_cheq_nume_cuen,     
                                v_cheq_user,          
                                v_cheq_fech_grab,     
                                v_cheq_cuen_codi,     
                                v_cheq_indi_ingr_manu,
                                v_cheq_orde, 
                                v_cheq_tasa_mone,     
                                null,
                                v_cheq_titu,
                                v_cheq_indi_terc) ;         
              
     exception 
   when others then 
     raise_application_error(-20010, 'Error al insertar en come cheque: '||sqlcode);
 end;            
 
            v_chmo_cheq_esta := v_cheq_esta; 
   
 begin         
           i020014.pp_inse_come_movi_cheq (v_chmo_movi_codi,
                                      v_chmo_cheq_codi,
                                      v_chmo_esta_ante,
                                      v_chmo_cheq_secu,
                                      p_codi_base,
                                      v_chmo_cheq_esta,
                                      v_chmo_asie_codi)  ;
          
    exception 
   when others then 
     raise_application_error(-20010, 'Error al insertar en come movi cheque: '||sqlcode);
 end;           

  
        --actualizar moimpo 
        v_moim_movi_codi :=  v_movi_codi;
        v_moim_nume_item :=  1;
        
         if i_cheq_fech_venc > i_cheq_fech_emis then --cheq. dif            
            v_moim_tipo      := 'Cheq. Dif. Rec.';
          else --cheque dia
            v_moim_tipo      := 'Cheq. dia. Rec.';            
          end if;     
        
        v_moim_cuen_codi := v_movi_cuen_codi;
        v_moim_dbcr      := v_movi_dbcr;
        v_moim_afec_caja := 'S';
        v_moim_fech      := v_movi_fech_emis;
        v_moim_fech_oper := v_movi_fech_oper;
        v_moim_impo_mone := v_movi_exen_mone;
        v_moim_impo_mmnn := v_movi_exen_mmnn;
        v_moim_cheq_codi := v_cheq_codi;
   
 begin     
       i020014.pp_inse_come_movi_impo_deta(v_moim_movi_codi,
                                        v_moim_nume_item,
                                        v_moim_tipo,
                                        v_moim_cuen_codi,
                                        v_moim_dbcr,
                                        v_moim_afec_caja,
                                        v_moim_fech,
                                        v_moim_fech_oper,
                                        v_moim_impo_mone,
                                        v_moim_impo_mmnn,       
                                        v_moim_cheq_codi);

  exception 
   when others then 
     raise_application_error(-20010, 'Error al insertar en importe deta: '||sqlcode);
 end;    

end pp_actu_regi;  
  
procedure pp_inse_come_cheq(p_cheq_codi           number,
                              p_cheq_mone_codi      number,
                              p_cheq_banc_codi      number,
                              p_cheq_nume           number,
                              p_cheq_serie          varchar2,
                              p_cheq_fech_emis      date,
                              p_cheq_fech_venc      date,
                              p_cheq_impo_mone      number,
                              p_cheq_impo_mmnn      number,
                              p_cheq_tipo           varchar2,
                              p_cheq_clpr_codi      number,
                              p_cheq_esta           varchar2,
                              p_cheq_nume_cuen      varchar2,
                              p_cheq_user           varchar2,
                              p_cheq_fech_grab      date,
                              p_cheq_cuen_codi      number,
                              p_cheq_indi_ingr_manu varchar2,
                              p_cheq_orde           varchar2,
                              p_cheq_tasa_mone      number,
                              p_cheq_tach_codi      number,
                              p_cheq_titu           varchar2,
                              p_cheq_indi_terc      varchar2) is
begin
  insert into come_cheq
    (cheq_codi,
     cheq_mone_codi,
     cheq_banc_codi,
     cheq_nume,
     cheq_serie,
     cheq_fech_emis,
     cheq_fech_venc,
     cheq_impo_mone,
     cheq_impo_mmnn,
     cheq_tipo,
     cheq_clpr_codi,
     cheq_esta,
     cheq_nume_cuen,
     cheq_user,
     cheq_fech_grab,
     cheq_cuen_codi,
     cheq_indi_ingr_manu,
     cheq_orde,
     cheq_tasa_mone,
     cheq_tach_codi,
     cheq_base,
     cheq_titu,
     cheq_indi_terc)
  values
    (p_cheq_codi,
     p_cheq_mone_codi,
     p_cheq_banc_codi,
     p_cheq_nume,
     p_cheq_serie,
     p_cheq_fech_emis,
     p_cheq_fech_venc,
     p_cheq_impo_mone,
     p_cheq_impo_mmnn,
     p_cheq_tipo,
     p_cheq_clpr_codi,
     p_cheq_esta,
     p_cheq_nume_cuen,
     p_cheq_user,
     p_cheq_fech_grab,
     p_cheq_cuen_codi,
     p_cheq_indi_ingr_manu,
     p_cheq_orde,
     p_cheq_tasa_mone,
     p_cheq_tach_codi,
     p_codi_base,
     p_cheq_titu,
     p_cheq_indi_terc);

end pp_inse_come_cheq;

procedure pp_inse_come_movi  (p_movi_codi           in number,
                              p_movi_timo_codi      in number,
                              p_movi_cuen_codi      in number,
                              p_movi_clpr_codi      in number,
                              p_movi_sucu_codi_orig in number,
                              p_movi_mone_codi      in number,
                              p_movi_nume           in number,
                              p_movi_fech_emis      in date,
                              p_movi_fech_grab      in date,
                              p_movi_fech_oper      in date,
                              p_movi_user           in char,
                              p_movi_codi_padr      in number,
                              p_movi_tasa_mone      in number,
                              p_movi_tasa_mmee      in number,
                              p_movi_grav_mmnn      in number,
                              p_movi_exen_mmnn      in number,
                              p_movi_iva_mmnn       in number,
                              p_movi_grav_mmee      in number,
                              p_movi_exen_mmee      in number,
                              p_movi_iva_mmee       in number,
                              p_movi_grav_mone      in number,
                              p_movi_exen_mone      in number,
                              p_movi_iva_mone       in number,
                              p_movi_clpr_desc      in char,
                              p_movi_emit_reci      in char,
                              p_movi_afec_sald      in char,
                              p_movi_dbcr           in char,
                              p_movi_empr_codi      in number,
                              p_movi_obse           in varchar2) is
begin
  
/*
insert into come_concat (campo1, otro) values (
                                           '  p_movi_codi: '||p_movi_codi||' ---- '||            
              '  p_movi_timo_codi: '||p_movi_timo_codi||' ---- '||           
              ' p_movi_cuen_codi: '||p_movi_cuen_codi||' ---- '||           
              ' p_movi_clpr_codi: '||p_movi_clpr_codi||' ---- '||           
              ' p_movi_sucu_codi_orig: '||p_movi_sucu_codi_orig||' ---- '||      
              ' p_movi_mone_codi: '||p_movi_mone_codi||' ---- '||           
              ' p_movi_nume: '||p_movi_nume||' ---- '||                
              ' p_movi_fech_emis: '||p_movi_fech_emis||' ---- '||           
              ' p_movi_fech_grab: '||p_movi_fech_grab||' ---- '||           
              ' p_movi_fech_oper: '||p_movi_fech_oper||' ---- '||           
              ' p_movi_user: '||p_movi_user||' ---- '||                
              ' p_movi_codi_padr: '||p_movi_codi_padr||' ---- '||           
              ' p_movi_tasa_mone: '||p_movi_tasa_mone||' ---- '||           
              ' p_movi_tasa_mmee: '||p_movi_tasa_mmee||' ---- '||           
              ' p_movi_grav_mmnn: '||p_movi_grav_mmnn||' ---- '||           
              ' p_movi_exen_mmnn: '||p_movi_exen_mmnn||' ---- '||           
              ' p_movi_iva_mmnn: '||p_movi_iva_mmnn||' ---- '||            
              ' p_movi_grav_mmee: '||p_movi_grav_mmee||' ---- '||           
              ' p_movi_exen_mmee: '||p_movi_exen_mmee||' ---- '||           
              ' p_movi_iva_mmee: '||p_movi_iva_mmee||' ---- '||            
              ' p_movi_grav_mone: '||p_movi_grav_mone||' ---- '||           
              ' p_movi_exen_mone: '||p_movi_exen_mone||' ---- '||           
              ' p_movi_iva_mone: '||p_movi_iva_mone||' ---- '||            
              ' p_movi_clpr_desc: '||p_movi_clpr_desc||' ---- '||           
              ' p_movi_emit_reci: '||p_movi_emit_reci||' ---- '||           
              ' p_movi_afec_sald: '||p_movi_afec_sald||' ---- '||           
              ' p_movi_dbcr: '||p_movi_dbcr||' ---- '||                
              ' p_movi_empr_codi: '||p_movi_empr_codi||' ---- '||          
              ' p_movi_obse: '||p_movi_obse||' ---- '                , 'LA INVESTIGACION ES PODEROSA'); commit;*/



  insert into come_movi
    (movi_codi,
     movi_timo_codi,
     movi_cuen_codi,
     movi_clpr_codi,
     movi_sucu_codi_orig,
     movi_mone_codi,
     movi_nume,
     movi_fech_emis,
     movi_fech_grab,
     movi_fech_oper,
     movi_user,
     movi_codi_padr,
     movi_tasa_mone,
     movi_tasa_mmee,
     movi_grav_mmnn,
     movi_exen_mmnn,
     movi_iva_mmnn,
     movi_grav_mmee,
     movi_exen_mmee,
     movi_iva_mmee,
     movi_grav_mone,
     movi_exen_mone,
     movi_iva_mone,
     movi_clpr_desc,
     movi_emit_reci,
     movi_afec_sald,
     movi_dbcr,
     movi_empr_codi,
     movi_base,
     movi_obse)
  values
    (p_movi_codi,
     p_movi_timo_codi,
     p_movi_cuen_codi,
     p_movi_clpr_codi,
     p_movi_sucu_codi_orig,
     p_movi_mone_codi,
     p_movi_nume,
     p_movi_fech_emis,
     p_movi_fech_grab,
     p_movi_fech_oper,
     p_movi_user,
     p_movi_codi_padr,
     p_movi_tasa_mone,
     p_movi_tasa_mmee,
     p_movi_grav_mmnn,
     p_movi_exen_mmnn,
     p_movi_iva_mmnn,
     p_movi_grav_mmee,
     p_movi_exen_mmee,
     p_movi_iva_mmee,
     p_movi_grav_mone,
     p_movi_exen_mone,
     p_movi_iva_mone,
     p_movi_clpr_desc,
     p_movi_emit_reci,
     p_movi_afec_sald,
     p_movi_dbcr,
     p_movi_empr_codi,
     p_codi_base,
     p_movi_obse);

end pp_inse_come_movi;

procedure pp_inse_movi_conc_deta(p_moco_movi_codi number,
                                 p_moco_nume_item number,
                                 p_moco_conc_codi number,
                                 p_moco_cuco_codi number,
                                 p_moco_impu_codi number,
                                 p_moco_impo_mmnn number,
                                 p_moco_impo_mmee number,
                                 p_moco_impo_mone number,
                                 p_moco_dbcr      char) is

begin
  insert into come_movi_conc_deta
    (moco_movi_codi,
     moco_nume_item,
     moco_conc_codi,
     moco_cuco_codi,
     moco_impu_codi,
     moco_impo_mmnn,
     moco_impo_mmee,
     moco_impo_mone,
     moco_dbcr,
     moco_base)
  values
    (p_moco_movi_codi,
     p_moco_nume_item,
     p_moco_conc_codi,
     p_moco_cuco_codi,
     p_moco_impu_codi,
     p_moco_impo_mmnn,
     p_moco_impo_mmee,
     p_moco_impo_mone,
     p_moco_dbcr,
     p_codi_base);

exception
  when others then
    raise_application_error(-20010, 'Codigo de concepto ' || p_codi_conc ||
          ' no encontrado: '||sqlcode);
end pp_inse_movi_conc_deta;


procedure pp_inse_come_movi_impu_deta(p_moim_impu_codi in number,
                                        p_moim_movi_codi in number,
                                        p_moim_impo_mmnn in number,
                                        p_moim_impo_mmee in number,
                                        p_moim_impu_mmnn in number,
                                        p_moim_impu_mmee in number,
                                        p_moim_impo_mone in number,
                                        p_moim_impu_mone in number) is
begin
  insert into come_movi_impu_deta
    (moim_impu_codi,
     moim_movi_codi,
     moim_impo_mmnn,
     moim_impo_mmee,
     moim_impu_mmnn,
     moim_impu_mmee,
     moim_impo_mone,
     moim_impu_mone,
     moim_base)
  values
    (p_moim_impu_codi,
     p_moim_movi_codi,
     p_moim_impo_mmnn,
     p_moim_impo_mmee,
     p_moim_impu_mmnn,
     p_moim_impu_mmee,
     p_moim_impo_mone,
     p_moim_impu_mone,
     p_codi_base);

end;


procedure pp_inse_come_movi_cheq(p_chmo_movi_codi in number,
                                 p_chmo_cheq_codi in number,
                                 p_chmo_esta_ante in varchar2,
                                 p_chmo_cheq_secu in number,
                                 p_chmo_base      in number,
                                 p_chmo_cheq_esta in varchar2,
                                 p_chmo_asie_codi in number) is

begin
  insert into come_movi_cheq
    (chmo_movi_codi,
     chmo_cheq_codi,
     chmo_esta_ante,
     chmo_cheq_secu,
     chmo_base,
     chmo_cheq_esta,
     chmo_asie_codi)
  values
    (p_chmo_movi_codi,
     p_chmo_cheq_codi,
     p_chmo_esta_ante,
     p_chmo_cheq_secu,
     p_chmo_base,
     p_chmo_cheq_esta,
     p_chmo_asie_codi);


end;

procedure pp_inse_come_movi_impo_deta(p_moim_movi_codi in number,
                                        p_moim_nume_item in number,
                                        p_moim_tipo      in char,
                                        p_moim_cuen_codi in number,
                                        p_moim_dbcr      in char,
                                        p_moim_afec_caja in char,
                                        p_moim_fech      in date,
                                        p_moim_fech_oper in date,
                                        p_moim_impo_mone in number,
                                        p_moim_impo_mmnn in number,
                                        p_moim_cheq_codi in number) is
begin
  insert into come_movi_impo_deta
    (moim_movi_codi,
     moim_nume_item,
     moim_tipo,
     moim_cuen_codi,
     moim_dbcr,
     moim_afec_caja,
     moim_fech,
     moim_fech_oper,
     moim_impo_mone,
     moim_impo_mmnn,
     moim_cheq_codi,
     moim_base)
  values
    (p_moim_movi_codi,
     p_moim_nume_item,
     p_moim_tipo,
     p_moim_cuen_codi,
     p_moim_dbcr,
     p_moim_afec_caja,
     p_moim_fech,
     p_moim_fech_oper,
     p_moim_impo_mone,
     p_moim_impo_mmnn,
     p_moim_cheq_codi,
     p_codi_base);

end;

/****************** VALIDACIONES **************/
 procedure pp_vali_caja (i_cheq_cuen_codi  in number,
                         o_cuen_desc       out come_cuen_banc.cuen_desc%type,
                         o_cuen_mone_codi  out come_cuen_banc.cuen_mone_codi%type,
                         o_banc_codi       out come_banc.banc_codi%type,
                         o_banc_desc       out come_banc.banc_desc%type,
                         o_cuen_nume       out come_cuen_banc.cuen_nume%type,
                         o_resp_codi       out number,
                         o_resp_desc       out varchar2) is
      
 
 v_banc_codi number;        
   begin
     
           select cuen_desc, 
                  cuen_mone_codi, 
                  banc_codi, 
                  banc_desc, 
                  cuen_nume
             into o_cuen_desc, 
                  o_cuen_mone_codi, 
                  v_banc_codi, 
                  o_banc_desc, 
                  o_cuen_nume
             from come_cuen_banc, come_banc
            where cuen_banc_codi = banc_codi(+)
              and cuen_codi = i_cheq_cuen_codi;

         if v_banc_codi is not null then
            pp_get_erro(i_resp_codi      => 2,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 105,
                        o_resp_desc      => v_erro_desc);
        
            v_erro_codi := 2;
            raise salir;
         else
           o_banc_codi := v_banc_codi;
         end if;  
         

  exception 
    when salir then   
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
    when no_data_found then 
        pp_get_erro(i_resp_codi      => 7,
                    i_resp_orig      => 1,
                    i_resp_segu_pant => 105,
                    o_resp_desc      => v_erro_desc);
                    
      o_resp_codi := 7;
      o_resp_desc := v_erro_desc;
   when others then
     o_resp_codi := 1000;
     o_resp_desc := 'Error al momento de validar Caja'||sqlcode;
      
end pp_vali_caja;
  
 procedure pp_vali_user (i_cheq_cuen_codi in number,   
                         o_resp_codi       out number,
                         o_resp_desc       out varchar2) is
    begin       
         if not i020014.fp_vali_user_cuen_banc_cred (i_cheq_cuen_codi) then
            pp_get_erro(i_resp_codi      => 3,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 105,
                        o_resp_desc      => v_erro_desc);
        
          v_erro_codi := 3;
          raise salir;
         end if;
 
  exception 
    when salir then 
      o_resp_codi := v_erro_codi;
      o_resp_desc := v_erro_desc;
   when others then
     o_resp_codi := 1000;
     o_resp_desc := 'Error al momento de validar usuario'||sqlcode;

 
 end pp_vali_user;
 
 procedure pp_vali_mone(i_cheq_mone_codi      in number,
                       o_cheq_mone_desc      out come_mone.mone_desc%type,
                       o_cheq_mone_desc_abre out come_mone.mone_desc_abre%type,
                       o_cheq_mone_cant_deci out come_mone.mone_cant_deci%type,
                       o_resp_codi           out number,
                       o_resp_desc           out varchar2) is

begin

  select mone_desc, mone_desc_abre, mone_cant_deci
    into o_cheq_mone_desc, o_cheq_mone_desc_abre, o_cheq_mone_cant_deci
    from come_mone
   where mone_codi = i_cheq_mone_codi;

exception
  when no_data_found then
    pp_get_erro(i_resp_codi      => 6,
                i_resp_orig      => 1,
                i_resp_segu_pant => 105,
                o_resp_desc      => v_erro_desc);
  
    v_erro_codi := 6;
    o_resp_codi := v_erro_codi;
    o_resp_desc := v_erro_desc;
  when others then
    o_resp_codi := 1000;
    o_resp_desc := 'Error al momento de cargar detalles de moneda: ' ||
                   sqlcode;
end pp_vali_mone;
       
 procedure pp_vali_cheq_nume(i_cheq_banc_codi in number,
                             i_cheq_seri      in varchar2,
                             i_cheq_nume      in varchar2,
                             i_cheq_tipo      in varchar2,
                             o_resp_codi      out number,
                             o_resp_desc      out varchar2) is
                            
    --v_where               char(100);
    v_cheq_codi           number;
    v_cheq_indi_ingr_manu varchar2(1);
    v_cheq_esta           varchar2(1);
 begin	
	
  select cheq_codi, nvl(cheq_indi_ingr_manu, 'N'), cheq_esta
    into v_cheq_codi, v_cheq_indi_ingr_manu, v_cheq_esta
    from come_cheq
   where cheq_serie = i_cheq_seri
     and cheq_banc_codi = i_cheq_banc_codi
     and cheq_nume = i_cheq_nume
     and cheq_tipo = i_cheq_tipo;
     
    pp_get_erro(i_resp_codi      => 8,
                i_resp_orig      => 1,
                i_resp_segu_pant => 105,
                o_resp_desc      => v_erro_desc);
  
    o_resp_codi := 8;
    o_resp_desc := v_erro_desc;
   
 
Exception
	 When no_data_found then 	   
	   null;  
end pp_vali_cheq_nume;

 procedure pp_vali_fech (i_fech      in date,
                         o_resp_codi out number,
                         o_resp_desc out varchar2) is
   
   begin
     
   pa_devu_fech_habi(p_fech_inic, p_fech_fini );
   

  if i_fech not between p_fech_inic and p_fech_fini then
    
   pp_get_erro(i_resp_codi       => 9,
                i_resp_orig      => 1,
                i_resp_segu_pant => 105,
                o_resp_desc      => v_erro_desc);
  
    v_erro_codi := 8;
    v_erro_desc := replace(replace(v_erro_desc, 'P_FECHA',to_char(p_fech_inic, 'dd-mm-yyyy')), 'P_HASTA', to_char(p_fech_fini, 'dd-mm-yyyy'));
   
  raise salir;
  end if;	
  

 exception 
   when salir then 
     o_resp_codi := v_erro_codi;
     o_resp_desc := v_erro_desc;  
   
   end pp_vali_fech;


/***************SUB VALIDACIONES *************/

--El objetivo de este procedimiento es validar que el usuario posea el permiso correspondiente para transferir una caja determintada a otra...
--independientemente de la pantalla en la q se encuentre, es solo otro nivel de seguridad, que esta por debajo del nivl de pantallas..
 function fp_vali_user_cuen_banc_cred(p_cuen_codi in number,
                                     p_fech      in date default sysdate,
                                     p_fech_oper in date default sysdate)
  return boolean is
  
  v_cuen_codi      number;
  v_indi_cier_caja varchar2(1);
  
begin
      select uc.usco_cuen_codi, c.cuen_indi_cier_caja
        into v_cuen_codi, v_indi_cier_caja
        from segu_user u, segu_user_cuen_orig uc, come_cuen_banc c
       where u.user_codi = uc.usco_user_codi
         and upper(rtrim(ltrim(u.user_login))) = upper(gen_user)
         and usco_cuen_codi = p_cuen_codi
         and uc.usco_cuen_codi = c.cuen_codi;

      i020014.pp_vali_cier_caja      (p_cuen_codi, p_fech, v_indi_cier_caja, v_erro_codi, v_erro_desc);

      i020014.pp_vali_cier_caja_oper (p_cuen_codi, p_fech_oper, v_erro_codi, v_erro_desc);

    if v_erro_codi is null then 
      return true;
    else
      return false;
    end if;

exception
  when no_data_found then
    return false;
  when others then
    return false;
end fp_vali_user_cuen_banc_cred;

 procedure pp_vali_cier_caja(p_cuen_codi      in number,
                            p_fech           in date default sysdate,
                            p_indi_cier_caja in char,
                            o_resp_codi      out number,
                            o_resp_desc      out varchar2) is
  v_cant      number;
  v_cant_movi number;
  v_hora_oper date;
  v_hora_sist date;

  v_indi_vali_cier_caja varchar2(30);
  v_cant_cier_caja      number := 0;
begin

  v_indi_vali_cier_caja := ltrim(rtrim(fa_busc_para('p_indi_vali_cier_caja')));
  v_cant_cier_caja      := ltrim(rtrim(fa_busc_para('p_cant_cier_caja')));

  if nvl(upper(v_indi_vali_cier_caja), 'N') = 'S' then
    if p_indi_cier_caja = 'S' then
      --Verifica si existe cierre de caja para el dia anterior
      select count(*)
        into v_cant
        from come_cier_caja c
       where c.caja_cuen_codi = p_cuen_codi
         and c.caja_fech = trunc(p_fech) - 1;
    
      select count(*)
        into v_cant_movi
        from come_movi,
             come_movi_impo_deta
        where moim_movi_codi = movi_codi
          and moim_cuen_codi = p_cuen_codi
          and moim_fech_oper = trunc(p_fech)-1;
        
      if v_cant = 0 then
        -- No existe cierre de caja para la fecha
        select count(*)
          into v_cant
          from come_movi m
         where m.movi_cuen_codi = p_cuen_codi
           and m.movi_fech_oper = trunc(p_fech) - 1;
      
        if v_cant <> 0 then
          -- Existen movimientos del dia anterior
          v_hora_oper := to_date('09:00:00', 'hh24:mi:ss');
          v_hora_sist := to_date(to_char(sysdate, 'hh24:mi:ss'), 'hh24:mi:ss');
        
          if v_hora_sist > v_hora_oper and v_cant_movi > 0 then
            -- Si la hora paso las 9 de la ma?ana
            pp_get_erro(i_resp_codi      => 4,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 105,
                        o_resp_desc      => v_erro_desc);
        
          v_erro_codi := 4;
          v_erro_desc :=  replace(replace(v_erro_desc, 'P_FECHA', to_char((trunc(p_fech)-1),'dd-mm-yyyy')), 'P_CUENTA' ,p_cuen_codi);  
          end if;
        
        end if;
      
      end if;
    end if;
  end if;
  
  if v_erro_codi is not null then 
    o_resp_desc := v_erro_desc; 
    o_resp_codi := v_erro_codi;
  end if;
  
end pp_vali_cier_caja;

 procedure pp_vali_cier_caja_oper (p_cuen_codi      in number,
			                            p_fech           in date default sysdate,
                                  o_resp_codi      out number,
                                  o_resp_desc      out varchar2) is
  v_cant      number;

  v_indi_vali_cier_caja varchar2(30);
  v_cant_cier_caja      number := 0;
begin

  v_indi_vali_cier_caja := ltrim(rtrim(fa_busc_para('p_indi_vali_cier_caja')));
  v_cant_cier_caja      := ltrim(rtrim(fa_busc_para('p_cant_cier_caja')));

  if nvl(upper(v_indi_vali_cier_caja), 'N') = 'S' then
    --Verifica si existe cierre en la fecha que se quiere cargar el movimiento.
    select count(*)
      into v_cant
      from come_cier_caja c
     where c.caja_cuen_codi = p_cuen_codi
       and c.caja_fech = trunc(p_fech);
    
    if v_cant > 0 and v_cant >= v_cant_cier_caja then
      -- Si ya se realizaron todos los cierres correspondientes, no debe permitir ingresar mas movimientos.      
      pp_get_erro(i_resp_codi      => 4,
                        i_resp_orig      => 1,
                        i_resp_segu_pant => 105,
                        o_resp_desc      => v_erro_desc);
        
          v_erro_codi := 4;
          v_erro_desc :=  replace(v_erro_desc, 'P_CANT', v_cant);  
    end if;
  end if;
  
  if v_erro_codi is not null then 
    o_resp_desc := v_erro_desc; 
    o_resp_codi := v_erro_codi;
  end if;
  
  
  
end pp_vali_cier_caja_oper; 


end I020014;
