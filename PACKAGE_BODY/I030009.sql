
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I030009" is

  -- Private type declarations
 
  type r_parameter is record(
    p_codi_clie_espo number:= to_number(general_skn.fl_busca_parametro ('p_codi_clie_espo')),
    p_codi_prov_espo number:= to_number(general_skn.fl_busca_parametro ('p_codi_prov_espo')),
    collection_name varchar2(30):='COLL_BRESUMEN',
    collection_name1 varchar2(30):='COLL_BDATOS'
  );
  parameter r_parameter;
  
  type r_bsel is record(
   cuen_codi number,
   tipo      varchar2(2),
   s_indi_mmnn varchar2(2),
   s_sald_inic number,
   fech_inic date,
   fech_fini date,
   s_sald_fini number,
   s_sald      number,
   mone_cant_deci number
  );
  bsel r_bsel;
  
  type r_bdatos is record(
       movi_codi number,
       movi_nume number,
       cheq_nume varchar2(30),
       movi_obse varchar2(2000),
       timo_desc_abre varchar2(100),
       moim_tipo      varchar2(100),
       clpr_desc      varchar2(100),
       moim_fech      date,
       movi_fech_emis date,
       db             number,
       cr             number,
       sald           number,
       sald_fini      number,
       sald_inic      number
  );
  bdatos r_bdatos;
  
  type r_bresumen is record(
    timo_desc varchar2(100),
    db        number,
    cr        number
  );
  bresumen r_bresumen;
  

-----------------------------------------------  
  procedure pp_mostrar_mone(p_mone_codi      in number,
                            p_mone_desc_abre out char,
                            p_mone_cant_deci out char) is
  begin
    select mone_desc_abre, mone_cant_deci
      into p_mone_desc_abre, p_mone_cant_deci
      from come_mone
     where mone_codi = p_mone_codi;

  Exception
    when no_data_found then
      p_mone_desc_abre := null;
      p_mone_cant_deci := null;
      --pl_mostrar_error('Moneda Inexistente!');
    when others then
      raise_application_error(-20010, 'Error al buscar Moneda! ' || sqlerrm);
  end pp_mostrar_mone;

-----------------------------------------------
  procedure pp_validar_caja(cuen_codi in number,
                            cuen_desc out varchar2,
                            mone_codi out number,
                            banc_codi out number,
                            banc_desc out varchar2,
                            cuen_nume out varchar2,
                            mone_desc_abre out varchar2,
                            mone_cant_deci out varchar2
                            ) is
  
  begin
    if cuen_codi is not null then
      
      general_skn.pl_muestra_come_cuen_banc(cuen_codi,
                                cuen_desc,
                                mone_codi,
                                banc_codi,
                                banc_desc,
                                cuen_nume);
      
      if not general_skn.fl_vali_user_cuen_banc_cons(cuen_codi) then
        raise_application_error(-20010,'No posee permiso para consultar la caja seleccionada. !!!');
      end if;
      
      pp_mostrar_mone(mone_codi,
                      mone_desc_abre,
                      mone_cant_deci);
      --pp_formatear_importes('N');
    else
      raise_application_error(-20010, 'Debe ingresar la Cuenta Bancaria');
    end if;
  
  end pp_validar_caja;
  
-----------------------------------------------
  procedure pp_validar_nulos(cuen_codi in number,
                             fech_inic in varchar2,
                             fech_fini in varchar2) is
    
  begin
    if cuen_codi is null then
      raise_application_error(-20010, 'Debe ingresar la Cuenta Bancaria!');
    end if;
    
    if fech_inic is null then
      raise_application_error(-20010, 'Debe ingresar la Fecha Desde!');
    end if;
    
    if fech_fini is null then
      raise_application_error(-20010, 'Debe ingresar la Fecha Hasta!');
    end if;    
    
  end pp_validar_nulos;

-----------------------------------------------
  procedure pp_cargar_variables(cuen_codi   in number,
                                tipo        in varchar2,
                                s_indi_mmnn in varchar2,
                                fech_inic   in date,
                                fech_fini   in date,
                                mone_cant_deci in number) is
  
  begin
    bsel.cuen_codi   := cuen_codi;
    bsel.tipo        := tipo;
    bsel.s_indi_mmnn := s_indi_mmnn;
    bsel.fech_inic   := fech_inic;
    bsel.fech_fini   := fech_fini;
    bsel.mone_cant_deci := mone_cant_deci;
    /*
    raise_application_error(-20010, 'bsel.cuen_codi: ' || bsel.cuen_codi ||';'||
                                    'bsel.fech_inic: ' ||bsel.fech_inic ||';'||
                                    'bsel.fech_fini: ' ||bsel.fech_fini 
                                    --'' ||';'||
    );
  */
  end pp_cargar_variables;
-----------------------------------------------
  procedure pp_cargar_saldo_ini is

    v_sald_inic_mmnn number;
    v_sald_inic_mone number;

  Begin
    select nvl(sald_inic_mmnn, 0), nvl(sald_inic_mone, 0)
      into v_sald_inic_mmnn, v_sald_inic_mone
      from come_cuen_banc_sald
     where sald_cuen_codi = bsel.cuen_codi
       and sald_fech = bsel.fech_inic;

    if bsel.s_indi_mmnn = 'S' then
       bsel.s_sald_inic := v_sald_inic_mmnn;
    else
       bsel.s_sald_inic := v_sald_inic_mone;
    end if;

  exception
    when no_data_found then
      bsel.s_sald_inic := 0;
  End pp_cargar_saldo_ini;

-----------------------------------------------
  procedure pp_cargar_saldo_ini_oper is

    v_sald_inic_mmnn number;
    v_sald_inic_mone number;

  Begin
    select nvl(sald_inic_mmnn, 0), nvl(sald_inic_mone, 0)
      into v_sald_inic_mmnn, v_sald_inic_mone
      from come_cuen_banc_sald_oper
     where sald_cuen_codi = bsel.cuen_codi
       and sald_fech = bsel.fech_inic;

    if bsel.s_indi_mmnn = 'S' then
      bsel.s_sald_inic := v_sald_inic_mmnn;
    else
      bsel.s_sald_inic := v_sald_inic_mone;
    end if;

  exception
    when no_data_found then
      bsel.s_sald_inic := 0;
  End pp_cargar_saldo_ini_oper;

-----------------------------------------------
  function fp_carga_depo_extr_socio(p_movi_codi in number) return varchar2 is
    v_desc varchar2(500) := ' ';

    cursor c_movi is
      select (soci_nomb || ' ' || soci_apel) || ' (' || soci_nume || ')' socio_desc
        from cope_movi, cope_soci
       where como_soci_codi = soci_codi
         and como_come_movi = p_movi_codi;

  Begin

    for x in c_movi loop
      v_desc := x.socio_desc;
      exit;
    end loop;
    return v_Desc;

  Exception
    When no_data_found then
      return ' ';
    
  End fp_carga_depo_extr_socio;

-----------------------------------------------
  FUNCTION fp_carga_caja_orig_dest(p_timo_codi in number,
                                   p_movi_codi in number) return varchar2 IS
    v_desc varchar2(100) := ' ';
  begin

    select 'C.O.: ' || ed.moim_cuen_codi || ' ' || ' C.D.: ' || '' ||
           dd.moim_cuen_codi
      into v_desc
      from come_movi           e,
           come_movi           d,
           come_movi_impo_deta ed,
           come_movi_impo_deta dd,
           come_cuen_banc      co,
           come_cuen_banc      cd
    
     where e.movi_codi_padr = d.movi_codi
       and ed.moim_movi_codi = e.movi_codi
       and dd.moim_movi_codi = d.movi_codi
       and ed.moim_cuen_codi = co.cuen_codi
       and dd.moim_cuen_codi = cd.cuen_codi
          
       and e.movi_timo_codi = 28
       and d.movi_timo_codi = 27
       and decode(p_timo_codi, 28, e.movi_codi, d.movi_codi) = p_movi_codi
     group by ed.moim_cuen_codi, dd.moim_cuen_codi;

    return v_desc;

  Exception
    when no_data_Found then
      v_desc := fp_carga_depo_extr_socio(p_movi_codi);
      return v_desc;
    when others then
      return v_desc;
    
  end fp_carga_caja_orig_dest;

-----------------------------------------------
  function fp_devu_nume_cheq(p_cheq_codi in number) RETURN varchar2 IS
    v_cheq_nume varchar2(30);
  BEGIN
    select cheq_nume
      into v_cheq_nume
      from come_cheq
     where cheq_codi = p_cheq_codi;

    return v_cheq_nume;
  exception
    when others then
      return null;
  END fp_devu_nume_cheq;

-----------------------------------------------
  function CF_conc_descFormula(i_movi_codi number) return Char is
    cursor c_conc(movi_codi number) is
      select ltrim(rtrim(conc_desc)) conc_desc
        from come_movi_conc_deta d, come_conc c
       where d.moco_conc_codi = c.conc_codi
         and d.moco_movi_codi = movi_codi
         and conc_codi not in (select nvl(impu_conc_codi_ivdb, -1)
                                 from come_impu
                               union
                               select nvl(impu_conc_codi_ivcr, -1)
                                 from come_impu)
       group by conc_desc;

    v_desc varchar2(200);
  begin

    for x in c_conc(i_movi_codi) loop
      v_desc := substr((v_desc || '-' || x.conc_desc), 1, 200);
    end loop;
    v_desc := substr(v_desc, 2, 199);
    return v_desc;
  end;

-----------------------------------------------  
  procedure pp_cargar_mov(p_fec_ini in date, p_fec_fin in date) is
    --debito  = (+)
    --credito = (-)    

    cursor c_movi is
      select t.timo_desc_abre,
             m.movi_nume movi_nume,
             i.moim_tipo,
             i.moim_dbcr,
             i.moim_cuen_codi,
             t.timo_codi,
             i.moim_fech fecha,
             m.movi_fech_emis,
             m.movi_obse,
             cp.clpr_desc,
             cp.clpr_codi_alte,
             cp.clpr_codi,
             cp.clpr_indi_clie_prov,
             m.movi_clpr_desc,
             m.movi_codi,
             i.moim_cheq_codi,
             decode(rtrim(ltrim(i.moim_dbcr)), 'C', nvl(moim_impo_mone, 0), 0) Cred_mone,
             decode(rtrim(ltrim(i.moim_dbcr)), 'C', nvl(moim_impo_mmnn, 0), 0) Cred_mmnn,
             decode(rtrim(ltrim(i.moim_dbcr)), 'D', nvl(moim_impo_mone, 0), 0) debi_mone,
             decode(rtrim(ltrim(i.moim_dbcr)), 'D', nvl(moim_impo_mmnn, 0), 0) debi_mmnn
        from come_movi           m,
             come_movi_impo_deta i,
             come_tipo_movi      t,
             come_clie_prov      cp
       where m.movi_codi = i.moim_movi_codi
         and m.movi_timo_codi = t.timo_codi
         and i.moim_cuen_codi = bsel.cuen_codi
         and m.movi_clpr_codi = cp.clpr_codi(+)
         and i.moim_afec_caja = 'S'
            --and m.movi_cuen_codi is not null
         and i.moim_fech between bsel.fech_inic and bsel.fech_fini
       order by i.moim_fech,
                moim_movi_codi,
                timo_desc_abre,
                movi_nume,
                moim_tipo;

    v_sald_inic number;
    v_sald_fini number;
    
    v_conc_desc varchar2(100);
    v_link      varchar2(1000):= '<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>';

  begin

    v_sald_inic := bsel.s_sald_inic;
    v_sald_fini := bsel.s_sald_inic;

    if bsel.s_indi_mmnn = 'S' then
      --Si es en moneda local  
      for x in c_movi loop
        
        v_sald_inic      := v_sald_fini;
        bdatos.sald_inic := v_sald_inic;
      
        bdatos.moim_fech      := x.fecha;
        bdatos.movi_fech_emis := x.movi_fech_emis;
        bdatos.moim_tipo      := x.moim_tipo;
        bdatos.movi_obse      := x.movi_obse;
        bdatos.movi_codi      := x.movi_codi;
      
        if x.timo_codi in (27, 28) then
          bdatos.clpr_desc := fp_carga_caja_orig_dest(x.timo_codi,x.movi_codi);
        else
          if x.clpr_indi_clie_prov = 'C' then
            if parameter.p_codi_clie_espo = x.clpr_codi_alte then
              bdatos.clpr_desc := x.movi_clpr_desc;
            else
              bdatos.clpr_desc := x.clpr_desc;
            end if;
          
          elsif x.clpr_indi_clie_prov = 'P' then
            if parameter.p_codi_prov_espo = x.clpr_codi_alte then
              bdatos.clpr_desc := x.movi_clpr_desc;
            else
              bdatos.clpr_desc := x.clpr_desc;
            end if;
          end if;
        end if;
      
        bdatos.movi_nume      := x.movi_nume;
        bdatos.timo_desc_abre := x.timo_Desc_abre;
      
        bdatos.db        := x.debi_mmnn;
        bdatos.cr        := x.cred_mmnn;
        v_sald_fini      := v_sald_inic + x.debi_mmnn - x.cred_mmnn;
        bdatos.sald_fini := v_sald_fini;
        bdatos.sald      := bdatos.sald_fini;
      
        bdatos.cheq_nume := fp_devu_nume_cheq(x.moim_cheq_codi);
   
        v_conc_desc:= CF_conc_descFormula(x.movi_codi);
         
        pack_mane_tabl_auxi.pp_add_members(i_taax_sess => v('APP_SESSION'),
                                           i_taax_user => gen_user,
                                           i_taax_c001 => bdatos.sald_inic,
                                           i_taax_c002 => bdatos.moim_fech,
                                           i_taax_c003 => bdatos.movi_fech_emis,
                                           i_taax_c004 => bdatos.moim_tipo,
                                           i_taax_c005 => bdatos.movi_obse,
                                           i_taax_c006 => bdatos.movi_codi,
                                           i_taax_c007 => bdatos.clpr_desc,
                                           i_taax_c008 => bdatos.movi_nume,
                                           i_taax_c009 => bdatos.timo_desc_abre,
                                           i_taax_c010 => bdatos.db,
                                           i_taax_c011 => bdatos.cr,
                                           i_taax_c012 => bdatos.sald_fini,
                                           i_taax_c013 => bdatos.sald,
                                           i_taax_c014 => bdatos.cheq_nume,
                                           i_taax_c015 => v_conc_desc,
                                           i_taax_c016 => v_link
                                           );
                                           
 /*
       apex_collection.add_member(p_collection_name => parameter.collection_name1,
                                   p_c001 => bdatos.sald_inic,
                                    p_c002 => bdatos.moim_fech,
                                    p_c003 => bdatos.movi_fech_emis,
                                    p_c004 => bdatos.moim_tipo,
                                    p_c005 => bdatos.movi_obse,
                                    p_c006 => bdatos.movi_codi,
                                    p_c007 => bdatos.clpr_desc,
                                    p_c008 => bdatos.movi_nume,
                                    p_c009 => bdatos.timo_desc_abre,
                                    p_c010 => bdatos.db,
                                    p_c011 => bdatos.cr,
                                    p_c012 => bdatos.sald_fini,
                                    p_c013 => bdatos.sald,
                                    p_c014 => bdatos.cheq_nume);
*/
      end loop;
      
    elsif bsel.s_indi_mmnn = 'N' then
      --Si es en la moneda de la Cta. bancaria 
      for x in c_movi loop
      
        v_sald_inic      := v_sald_fini;
        bdatos.sald_inic := v_sald_inic;
      
        bdatos.moim_fech      := x.fecha;
        bdatos.movi_fech_emis := x.movi_fech_emis;
        bdatos.moim_tipo      := x.moim_tipo;
        bdatos.movi_obse      := x.movi_obse;
        bdatos.movi_codi      := x.movi_codi;
        bdatos.cheq_nume      := fp_devu_nume_cheq(x.moim_cheq_codi);
      
        if x.timo_codi in (27, 28) then
          bdatos.clpr_desc := fp_carga_caja_orig_dest(x.timo_codi,
                                                      x.movi_codi);
        else
        
          if x.clpr_indi_clie_prov = 'C' then
            if parameter.p_codi_clie_espo = x.clpr_codi_alte then
              bdatos.clpr_desc := x.movi_clpr_desc;
            else
              bdatos.clpr_desc := x.clpr_desc;
            end if;
          
          elsif x.clpr_indi_clie_prov = 'P' then
            if parameter.p_codi_prov_espo = x.clpr_codi_alte then
              bdatos.clpr_desc := x.movi_clpr_desc;
            else
              bdatos.clpr_desc := x.clpr_desc;
            end if;
          end if;
        end if;
      
        bdatos.movi_nume      := x.movi_nume;
        bdatos.timo_desc_abre := x.timo_desc_abre;
      
        bdatos.db := x.debi_mone;
        bdatos.cr := x.cred_mone;
      
        v_sald_fini      := v_sald_inic + x.debi_mone - x.cred_mone;
        bdatos.sald_fini := v_sald_fini;
        bdatos.sald      := bdatos.sald_fini;
      
        v_conc_desc:= CF_conc_descFormula(x.movi_codi);
        
        pack_mane_tabl_auxi.pp_add_members(i_taax_sess => v('APP_SESSION'),
                                           i_taax_user => gen_user,
                                           i_taax_c001 => bdatos.sald_inic,
                                           i_taax_c002 => bdatos.moim_fech,
                                           i_taax_c003 => bdatos.movi_fech_emis,
                                           i_taax_c004 => bdatos.moim_tipo,
                                           i_taax_c005 => bdatos.movi_obse,
                                           i_taax_c006 => bdatos.movi_codi,
                                           i_taax_c007 => bdatos.clpr_desc,
                                           i_taax_c008 => bdatos.movi_nume,
                                           i_taax_c009 => bdatos.timo_desc_abre,
                                           i_taax_c010 => bdatos.db,
                                           i_taax_c011 => bdatos.cr,
                                           i_taax_c012 => bdatos.sald_fini,
                                           i_taax_c013 => bdatos.sald,
                                           i_taax_c014 => bdatos.cheq_nume,
                                           i_taax_c015 => v_conc_desc,
                                           i_taax_c016 => v_link);

/*     
       apex_collection.add_member(p_collection_name => parameter.collection_name1,
                                   p_c001 => bdatos.sald_inic,
                                    p_c002 => bdatos.moim_fech,
                                    p_c003 => bdatos.movi_fech_emis,
                                    p_c004 => bdatos.moim_tipo,
                                    p_c005 => bdatos.movi_obse,
                                    p_c006 => bdatos.movi_codi,
                                    p_c007 => bdatos.clpr_desc,
                                    p_c008 => bdatos.movi_nume,
                                    p_c009 => bdatos.timo_desc_abre,
                                    p_c010 => bdatos.db,
                                    p_c011 => bdatos.cr,
                                    p_c012 => bdatos.sald_fini,
                                    p_c013 => bdatos.sald,
                                    p_c014 => bdatos.cheq_nume);
*/
      end loop;
    
    end if;

    bsel.s_sald_fini := v_sald_fini;
    bsel.s_sald      := v_sald_fini;

  end pp_cargar_mov;

-----------------------------------------------
  procedure pp_cargar_mov_oper(p_fec_ini in date, p_fec_fin in date) is
    --debito  = (+)
    --credito = (-) 

    cursor c_movi is
      select t.timo_desc_abre,
             m.movi_nume movi_nume,
             i.moim_tipo,
             i.moim_dbcr,
             i.moim_cuen_codi,
             t.timo_codi,
             i.moim_fech_oper fecha,
             m.movi_fech_emis,
             m.movi_obse,
             cp.clpr_desc,
             m.movi_codi,
             cp.clpr_codi_alte,
             cp.clpr_codi,
             cp.clpr_indi_clie_prov,
             m.movi_clpr_desc,
             i.moim_cheq_codi,
             decode(rtrim(ltrim(i.moim_dbcr)), 'C', nvl(moim_impo_mone, 0), 0) Cred_mone,
             decode(rtrim(ltrim(i.moim_dbcr)), 'C', nvl(moim_impo_mmnn, 0), 0) Cred_mmnn,
             decode(rtrim(ltrim(i.moim_dbcr)), 'D', nvl(moim_impo_mone, 0), 0) debi_mone,
             decode(rtrim(ltrim(i.moim_dbcr)), 'D', nvl(moim_impo_mmnn, 0), 0) debi_mmnn
        from come_movi           m,
             come_movi_impo_deta i,
             come_tipo_movi      t,
             come_clie_prov      cp
       where m.movi_codi = i.moim_movi_codi
         and m.movi_timo_codi = t.timo_codi
         and i.moim_cuen_codi = bsel.cuen_codi
         and m.movi_clpr_codi = cp.clpr_codi(+)
         and i.moim_afec_caja = 'S'
            --and m.movi_cuen_codi is not null
         and i.moim_fech_oper between p_fec_ini and p_fec_fin
       order by i.moim_fech_oper,
                i.moim_movi_codi,
                timo_desc_abre,
                movi_nume,
                moim_tipo;

    v_sald_inic number;
    v_sald_fini number;
    
    v_conc_desc varchar2(100);
    v_link      varchar2(1000):='<span aria-label="Edit"><span class="fa fa-edit" aria-hidden="true" title="Edit"></span></span>';

  begin

    v_sald_inic := bsel.s_sald_inic;
    v_sald_fini := bsel.s_sald_inic;

    if bsel.s_indi_mmnn = 'S' then
      --Si es en moneda local  
    
      for x in c_movi loop
        
        v_sald_inic      := v_sald_fini;
        bdatos.sald_inic := v_sald_inic;
      
        bdatos.moim_fech      := x.fecha;
        bdatos.movi_fech_emis := x.movi_fech_emis;
        bdatos.moim_tipo      := x.moim_tipo;
        bdatos.movi_obse      := x.movi_obse;
        bdatos.movi_codi      := x.movi_codi;
      
        if x.timo_codi in (27, 28) then
          bdatos.clpr_desc := fp_carga_caja_orig_dest(x.timo_codi,
                                                      x.movi_codi);
        else
          if x.clpr_indi_clie_prov = 'C' then
            if parameter.p_codi_clie_espo = x.clpr_codi_alte then
              bdatos.clpr_desc := x.movi_clpr_desc;
            else
              bdatos.clpr_desc := x.clpr_desc;
            end if;
          elsif x.clpr_indi_clie_prov = 'P' then
            if parameter.p_codi_prov_espo = x.clpr_codi_alte then
              bdatos.clpr_desc := x.movi_clpr_desc;
            else
              bdatos.clpr_desc := x.clpr_desc;
            end if;
          end if;
        end if;
      
        bdatos.movi_nume      := x.movi_nume;
        bdatos.cheq_nume      := fp_devu_nume_cheq(x.moim_cheq_codi);
        bdatos.timo_desc_abre := x.timo_Desc_abre;
      
        bdatos.db        := x.debi_mmnn;
        bdatos.cr        := x.cred_mmnn;
        v_sald_fini      := v_sald_inic + x.debi_mmnn - x.cred_mmnn;
        bdatos.sald_fini := v_sald_fini;
        bdatos.sald      := bdatos.sald_fini;
      
        v_conc_desc:= CF_conc_descFormula(x.movi_codi);
        
        pack_mane_tabl_auxi.pp_add_members(i_taax_sess => v('APP_SESSION'),
                                           i_taax_user => gen_user,
                                           i_taax_c001 => bdatos.sald_inic,
                                           i_taax_c002 => bdatos.moim_fech,
                                           i_taax_c003 => bdatos.movi_fech_emis,
                                           i_taax_c004 => bdatos.moim_tipo,
                                           i_taax_c005 => bdatos.movi_obse,
                                           i_taax_c006 => bdatos.movi_codi,
                                           i_taax_c007 => bdatos.clpr_desc,
                                           i_taax_c008 => bdatos.movi_nume,
                                           i_taax_c009 => bdatos.timo_desc_abre,
                                           i_taax_c010 => bdatos.db,
                                           i_taax_c011 => bdatos.cr,
                                           i_taax_c012 => bdatos.sald_fini,
                                           i_taax_c013 => bdatos.sald,
                                           i_taax_c014 => bdatos.cheq_nume,
                                           i_taax_c015 => v_conc_desc,
                                           i_taax_c016 => v_link);
      
      end loop;
    elsif bsel.s_indi_mmnn = 'N' then
      
      --Si es en la moneda de la Cta. bancaria 
    
      for x in c_movi loop
      
        v_sald_inic      := v_sald_fini;
        bdatos.sald_inic := v_sald_inic;
      
        bdatos.moim_fech      := x.fecha;
        bdatos.movi_fech_emis := x.movi_fech_emis;
        bdatos.moim_tipo      := x.moim_tipo;
        bdatos.movi_obse      := x.movi_obse;
        bdatos.movi_codi      := x.movi_codi;
      
        if x.timo_codi in (27, 28) then
          bdatos.clpr_desc := fp_carga_caja_orig_dest(x.timo_codi,
                                                      x.movi_codi);
        else
          if x.clpr_indi_clie_prov = 'C' then
            if parameter.p_codi_clie_espo = x.clpr_codi_alte then
              bdatos.clpr_desc := x.movi_clpr_desc;
            else
              bdatos.clpr_desc := x.clpr_desc;
            end if;
          elsif x.clpr_indi_clie_prov = 'P' then
            if parameter.p_codi_prov_espo = x.clpr_codi_alte then
              bdatos.clpr_desc := x.movi_clpr_desc;
            else
              bdatos.clpr_desc := x.clpr_desc;
            end if;
          end if;
        end if;
      
        bdatos.movi_nume      := x.movi_nume;
        bdatos.cheq_nume      := fp_devu_nume_cheq(x.moim_cheq_codi);
        bdatos.timo_desc_abre := x.timo_desc_abre;
      
        bdatos.db := x.debi_mone;
        bdatos.cr := x.cred_mone;
      
        v_sald_fini      := v_sald_inic + x.debi_mone - x.cred_mone;
        bdatos.sald_fini := v_sald_fini;
        bdatos.sald      := bdatos.sald_fini;
      
        v_conc_desc:= CF_conc_descFormula(x.movi_codi);
        
        pack_mane_tabl_auxi.pp_add_members(i_taax_sess => v('APP_SESSION'),
                                           i_taax_user => gen_user,
                                           i_taax_c001 => bdatos.sald_inic,
                                           i_taax_c002 => bdatos.moim_fech,
                                           i_taax_c003 => bdatos.movi_fech_emis,
                                           i_taax_c004 => bdatos.moim_tipo,
                                           i_taax_c005 => bdatos.movi_obse,
                                           i_taax_c006 => bdatos.movi_codi,
                                           i_taax_c007 => bdatos.clpr_desc,
                                           i_taax_c008 => bdatos.movi_nume,
                                           i_taax_c009 => bdatos.timo_desc_abre,
                                           i_taax_c010 => bdatos.db,
                                           i_taax_c011 => bdatos.cr,
                                           i_taax_c012 => bdatos.sald_fini,
                                           i_taax_c013 => bdatos.sald,
                                           i_taax_c014 => bdatos.cheq_nume,
                                           i_taax_c015 => v_conc_desc,
                                           i_taax_c016 => v_link);
                                           
      end loop;
    end if;

    bsel.s_sald_fini := v_sald_fini;
    bsel.s_sald      := v_sald_fini;

  exception
    when others then
      raise_application_error(-20010,'Error! '||sqlerrm);
      
  end pp_cargar_mov_oper;

-----------------------------------------------
  procedure pp_cargar_mov_resu(p_fec_ini   in date,
                               p_fec_fin   in date,
                               p_indi_fech in varchar2,
                               s_indi_mmnn in varchar2
                               ) is
    --debito  = (+)
    --credito = (-)

    cursor c_movi is
      select t.timo_desc,
             sum(decode(rtrim(ltrim(i.moim_dbcr)),
                        'C',
                        nvl(-moim_impo_mone, 0),
                        nvl(moim_impo_mone, 0))) impo_mone,
             sum(decode(rtrim(ltrim(i.moim_dbcr)),
                        'C',
                        nvl(-moim_impo_mmnn, 0),
                        nvl(moim_impo_mmnn, 0))) impo_mmnn
        from come_movi           m,
             come_movi_impo_deta i,
             come_tipo_movi      t,
             come_clie_prov      cp
       where m.movi_codi = i.moim_movi_codi
         and m.movi_timo_codi = t.timo_codi
         and i.moim_cuen_codi = bsel.cuen_codi
         and m.movi_clpr_codi = cp.clpr_codi(+)
         and i.moim_afec_caja = 'S'
         and ((i.moim_fech_oper between to_date(bsel.fech_inic,'dd/mm/yyyy') and to_date(bsel.fech_fini,'dd/mm/yyyy') and
             p_indi_fech = 'O') --- operacion
             or (i.moim_fech between to_date(bsel.fech_inic,'dd/mm/yyyy') and to_date(bsel.fech_fini,'dd/mm/yyyy') and
             p_indi_fech = 'D')) --- documento
       group by t.timo_desc
       order by t.timo_desc;

    v_sald_inic number;
    v_sald_fini number;

  begin
    --raise_application_error(-2010,'');
    --raise_application_error(-20010,'resul:'|| p_fec_ini ||' ; '||p_fec_fin ||' ; '||p_indi_fech);
    --raise_application_error(-20010,'resul:'||bsel.s_indi_mmnn);

    if s_indi_mmnn = 'S' then
      --raise_application_error(-20010,'s_indi_mmnn: '|| s_indi_mmnn);
      
      --Si es en moneda local  
      for x in c_movi loop
      
        bresumen.timo_desc := x.timo_Desc;
      
        if x.impo_mmnn >= 0 then
          bresumen.db := abs(x.impo_mmnn);
          bresumen.cr := 0;
        else
          bresumen.cr := abs(x.impo_mmnn);
          bresumen.db := 0;
        end if;
      
        apex_collection.add_member(p_collection_name => parameter.collection_name,
                                   p_c001            => bresumen.timo_desc,
                                   p_c002            => bresumen.db,
                                   p_c003            => bresumen.cr);
      
      end loop;
    
    elsif s_indi_mmnn = 'N' then
      
      --Si es en la moneda de la Cta. bancaria 
      for x    in c_movi loop
      
        bresumen.timo_desc := x.timo_Desc;
        if x.impo_mmnn >= 0 then
          bresumen.db := abs(x.impo_mone);
          bresumen.cr := 0;
        else
          bresumen.cr := abs(x.impo_mone);
          bresumen.db := 0;
        end if;
      
        apex_collection.add_member(p_collection_name => parameter.collection_name,
                                   p_c001            => bresumen.timo_desc,
                                   p_c002            => bresumen.db,
                                   p_c003            => bresumen.cr);
      
      end loop;
    
    end if;

  end pp_cargar_mov_resu;

-----------------------------------------------
  procedure pp_send_value is

  begin
    
    --SETITEM('P28_S_SALD_INIC', fp_devu_mask(nvl(bsel.mone_cant_deci,0),bsel.s_sald_inic)); 
    SETITEM('P28_S_SALD_INIC', bsel.s_sald_inic); 
    --SETITEM('P28_S_SALD_FINI', fp_devu_mask(nvl(bsel.mone_cant_deci,0),bsel.s_sald_fini));
    SETITEM('P28_S_SALD_FINI', bsel.s_sald_fini);
    
  end pp_send_value;

-----------------------------------------------  
  procedure pp_consultar(cuen_codi in number,
                         tipo      in varchar2,
                         s_indi_mmnn in varchar2,
                         fech_inic in varchar2,
                         fech_fini in varchar2,
                         mone_cant_deci in number
                         ) is
    
  begin
    
    pp_validar_nulos(cuen_codi,fech_inic,fech_fini);
    
    pp_cargar_variables(cuen_codi,tipo,s_indi_mmnn,fech_inic,fech_fini,mone_cant_deci);
    
    if bsel.tipo='D' then
      pp_cargar_saldo_ini;
    else
       pp_cargar_saldo_ini_oper;
    end if;
    
    if bsel.tipo = 'D' then
      pp_cargar_mov(bsel.fech_inic, bsel.fech_fini);
    else
      pp_cargar_mov_oper(bsel.fech_inic, bsel.fech_fini);
    end if;	
    
     pp_cargar_mov_resu(fech_inic,
                               fech_fini,
                               tipo,
                               s_indi_mmnn
                               );
                               
     pp_send_value;
     
     
  end pp_consultar;

-----------------------------------------------
  procedure pp_imprimir_reportes (i_cuen_codi in number,
                                  i_cuen_desc in varchar2,
                                  i_fech_inic in varchar2,
                                  i_fech_fini in varchar2,
                                  i_sald_inic in varchar2,
                                  i_indi_mmnn in varchar2,
                                  i_mone_cant_deci in number
                                  ) is

  v_report       VARCHAR2(50);
  v_parametros   CLOB;
  v_contenedores CLOB;
  
  v_sald_inic number;
  --v_inic varchar2(100)--number;
  

  begin
    
    select to_number(trim(replace(i_sald_inic,'.','')))
    into v_sald_inic
    from dual;
    
    --raise_application_error(-20010,'v_sald_inic: '||v_sald_inic);
                          
    V_CONTENEDORES := 'p_cuen_codi:p_cuen_desc:p_fech_inic:p_fech_fini:p_sald_inic:p_indi_mmnn:p_user:p_session:p_mone_cant_deci';

    V_PARAMETROS   :=   i_cuen_codi      || ':' ||
                        rtrim(ltrim(i_cuen_desc))      || ':' ||
                        i_fech_inic      || ':' ||
                        i_fech_fini      || ':' ||
                        v_sald_inic      || ':' ||
                        i_indi_mmnn      || ':' ||
                        gen_user         || ':' ||
                        v('APP_SESSION') || ':' ||
                        i_mone_cant_deci
                        ;

    v_report       :='I030009';

    DELETE FROM COME_PARAMETROS_REPORT WHERE USUARIO = gen_user;

    INSERT INTO COME_PARAMETROS_REPORT
      (PARAMETROS, USUARIO, NOMBRE_REPORTE, FORMATO_SALIDA, NOM_PARAMETROS)
    VALUES
      (V_PARAMETROS, v('APP_USER'), v_report, 'pdf', V_CONTENEDORES);

    commit;
  
  /*exception
    when others then
      raise_application_error(-2010,'Error! '||sqlerrm);*/
      
  end pp_imprimir_reportes;

-----------------------------------------------

  procedure pp_validar_perfil(indi_pagi out number) is
    
    v_user varchar2(50);
    v_cant number;
    
  begin
    
    v_user:= gen_user;
    
      select count(*)
      into v_cant
      from segu_user u, SEGU_PANT_PERF p, segu_user_perf
      where p.pape_perf_codi = u.USER_PERF_CODI
      and   p.pape_base      = u.user_base
      and   u.user_login     = v_user
      and   p.pape_pant_codi = 224;--es el codigo de la pagina de segu_pant(Consulta de documentos)  
    
      if v_cant = 0 then
        select count(*)     
         into v_cant
        from SEGU_PANT_PERF p, (select user_codi, user_base, user_desc, f.uspe_perf_codi
                                from segu_user u, segu_user_perf f
                                where u.user_login     = gen_user
                                  and uspe_user_codi = user_codi
                                  and uspe_base = user_base) c
        where p.pape_perf_codi = c.uspe_perf_codi
        and   p.pape_base      = c.user_base
        and   p.pape_pant_codi = 224;
        
      end if;
    
    indi_pagi:=v_cant;
    
  end pp_validar_perfil;
-----------------------------------------------




end I030009;
