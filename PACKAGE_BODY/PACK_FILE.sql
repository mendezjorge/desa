
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."PACK_FILE" is

  procedure pp_get_file(v_desc in varchar2, v_file out blob) is

    l_file blob;
  begin
    l_file := dbms_cloud.get_object(credential_name => 'alarmas_file_access',
                                    object_uri      => 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/' ||
                                                       'p/1Ne2cl-zi5iu13gkEBHigHUisjE42RF2vduwlotyLHrvruZNUiSMoUcbsvY0-0sz/n/grcrplvrg8aa/b/files_alarmas/o/' ||
                                                      --'p/4N4N8qJ_lgVTrXSZ_-QPSAF1feUjk5VK4lqeLEvSyfWSTtB878X0lVx-IbIkn08S/n/grcrplvrg8aa/b/files_alarmas/o/' ||
                                                       v_desc);

    v_file := l_file;

    --para ver el archvio
    /* select dbms_cloud.get_object(credential_name => 'alarmas_file_access',
                               object_uri      => 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/'||
                               'p/1Ne2cl-zi5iu13gkEBHigHUisjE42RF2vduwlotyLHrvruZNUiSMoUcbsvY0-0sz/n/grcrplvrg8aa/b/files_alarmas/o/'||
                               'test2.txt') as metadata
    from dual;*/

  exception
    when others then
      v_file := null;
      pl_me(sqlerrm);
  end;

  procedure pp_get_file_desc(v_desc in varchar2, v_file out blob) is
    l_compressed_blob   blob;
    l_uncompressed_blob blob;
    l_dest_offset       number := 1;
    l_src_offset        number := 1;
    l_lang_context      number := dbms_lob.default_lang_ctx;
    l_warning           number;
  begin
    -- Crear un BLOB temporal para almacenar el archivo comprimido descargado
    DBMS_LOB.CREATETEMPORARY(l_compressed_blob, true);

    -- Descargar el archivo desde Oracle Cloud Storage
    l_compressed_blob := DBMS_CLOUD.get_object(credential_name => 'alarmas_file_access',
                                               object_uri      => 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/' ||
                                                                  'p/1Ne2cl-zi5iu13gkEBHigHUisjE42RF2vduwlotyLHrvruZNUiSMoUcbsvY0-0sz/n/grcrplvrg8aa/b/files_alarmas/o/' ||
                                                                  v_desc);

    -- Crear un BLOB temporal para almacenar el contenido descomprimido
    DBMS_LOB.CREATETEMPORARY(l_uncompressed_blob, true);

    -- Descomprimir el BLOB
    UTL_COMPRESS.lz_uncompress(l_compressed_blob, l_uncompressed_blob);

    -- Asignar el contenido descomprimido a la variable de salida
    v_file := l_uncompressed_blob;

    -- Liberar los BLOBs temporales
    DBMS_LOB.FREETEMPORARY(l_compressed_blob);
    DBMS_LOB.FREETEMPORARY(l_uncompressed_blob);

  exception
    when others then
      v_file := null;
      -- Manejar la excepción, por ejemplo, registrando el error
      DBMS_OUTPUT.put_line(sqlerrm);
  end;

  procedure pp_put_file(v_file_blob in blob default null,
                        v_file_clob in clob default null,
                        v_mime_type in varchar2,
                        v_tipo      in varchar,
                        v_empr_codi in number,
                        v_file_id   out number) is

    v_files_archivos_seq number;
    l_file_blob          blob;
    l_temp_blob          blob;
    l_file_clob          clob;
    v_desc               varchar2(500);
    v_empr_desc          varchar2(500);
    v_desc_arch          varchar2(500);
    v_exte               varchar2(500);
    l_dest_offset        number := 1;
    l_src_offset         number := 1;
    l_lang_context       number := dbms_lob.default_lang_ctx;
    l_warning            number;
    e_file_null          exception;

  begin

    select files_archivos_seq.nextval into v_files_archivos_seq from dual;

    select replace(replace(empr_desc, ' ', ''), '.', '')
      into v_empr_desc
      from come_empr
     where empr_codi = v_empr_codi;

    v_exte      := substr(v_mime_type, instr(v_mime_type, '/') + 1);
    v_desc_arch := v_empr_desc || '_' || v_tipo || '_' ||
                   v_files_archivos_seq;
    v_desc      := v_empr_desc || '_' || v_tipo || '_' ||
                   v_files_archivos_seq || '.' || v_exte;

    if v_file_blob is not null then
      l_file_blob := v_file_blob;
      v_file_id   := v_files_archivos_seq;

      dbms_cloud.put_object(credential_name => 'alarmas_file_access',
                            object_uri      => 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/' ||
                                               'p/1Ne2cl-zi5iu13gkEBHigHUisjE42RF2vduwlotyLHrvruZNUiSMoUcbsvY0-0sz/n/grcrplvrg8aa/b/files_alarmas/o/' ||
                                               v_desc,
                            contents        => l_file_blob);

    elsif v_file_clob is not null then

      l_file_clob := v_file_clob;
      v_file_id   := v_files_archivos_seq;
      dbms_lob.createtemporary(l_temp_blob, true);
      dbms_lob.converttoblob(l_temp_blob,
                             l_file_clob,
                             dbms_lob.lobmaxsize,
                             l_dest_offset,
                             l_src_offset,
                             dbms_lob.default_csid,
                             l_lang_context,
                             l_warning);

      dbms_cloud.put_object(credential_name => 'alarmas_file_access',
                            object_uri      => 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/' ||
                                               'p/1Ne2cl-zi5iu13gkEBHigHUisjE42RF2vduwlotyLHrvruZNUiSMoUcbsvY0-0sz/n/grcrplvrg8aa/b/files_alarmas/o/' ||
                                               v_desc,
                            contents        => l_temp_blob);

      dbms_lob.freetemporary(l_temp_blob);

    else

      insert into AUDI_FILES_ARCHIVOS
        (aufi_file_id, aufi_oci_file_id, aufi_esta, aufi_orig_tabl)
      values
        (v_file_id, v_desc, 'N', v_tipo);

      commit;

      raise e_file_null;

    end if;

    insert into files_archivos
      (file_id,
       file_desc,
       file_name,
       file_mime_type,
       file_created_by,
       file_created_on,
       file_empr_codi,
       file_desc_auto)
    values
      (v_files_archivos_seq,
       v_desc_arch,
       v_desc_arch,
       v_mime_type,
       fa_user,
       sysdate,
       v_empr_codi,
       v_desc);

   /* insert into AUDI_FILES_ARCHIVOS
      (aufi_file_id, aufi_oci_file_id, aufi_esta, aufi_orig_tabl)
    values
      (v_file_id, v_desc, 'S', v_tipo);*/
    commit;

  exception
    when e_file_null then
      raise_application_error(-20010, 'Ningun archivo fue cargado');
    when others then
       raise_application_error(-20010, sqlerrm);


  end;

  procedure pp_put_file_comp(v_file_blob in blob default null,
                             v_file_clob in clob default null,
                             v_mime_type in varchar2,
                             v_tipo      in varchar,
                             v_empr_codi in number,
                             v_file_id   out number) is

    v_files_archivos_seq number;
    l_file_blob          blob;
    l_compressed_blob    blob;
    l_file_clob          clob;
    v_desc               varchar2(500);
    v_empr_desc          varchar2(500);
    v_desc_arch          varchar2(500);
    v_exte               varchar2(500);
    l_dest_offset        number := 1;
    l_src_offset         number := 1;
    l_lang_context       number := dbms_lob.default_lang_ctx;
    l_warning            number;
    e_file_null          exception;

  begin

    select files_archivos_seq.nextval into v_files_archivos_seq from dual;

    select replace(replace(empr_desc, ' ', ''), '.', '')
      into v_empr_desc
      from come_empr
     where empr_codi = v_empr_codi;

    v_exte      := SUBSTR(v_mime_type, INSTR(v_mime_type, '/') + 1);
    v_desc_arch := v_empr_desc || '_' || v_tipo || '_' ||
                   v_files_archivos_seq;
    v_desc      := v_empr_desc || '_' || v_tipo || '_' ||
                   v_files_archivos_seq || '.' || v_exte;

    if v_file_blob is not null then

      v_file_id   := v_files_archivos_seq;
      l_file_blob := v_file_blob;
      -- Compress the blob
      dbms_lob.createtemporary(l_compressed_blob, true);
      utl_compress.lz_compress(l_file_blob, l_compressed_blob);
      v_desc := v_desc || '.gz'; -- Adjusting file name to reflect compression
      --v_mime_type := 'application/gzip'; -- Updating MIME type

      dbms_cloud.put_object(credential_name => 'alarmas_file_access',
                            object_uri      => 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/' ||
                                               'p/1Ne2cl-zi5iu13gkEBHigHUisjE42RF2vduwlotyLHrvruZNUiSMoUcbsvY0-0sz/n/grcrplvrg8aa/b/files_alarmas/o/' ||
                                               v_desc,
                            contents        => l_compressed_blob);

      dbms_lob.freetemporary(l_compressed_blob);

      insert into files_archivos
        (file_id,
         file_desc,
         file_name,
         file_mime_type,
         file_created_by,
         file_created_on,
         file_empr_codi,
         file_desc_auto)
      values
        (v_files_archivos_seq,
         v_desc_arch,
         v_desc_arch,
         v_mime_type,
         fa_user,
         sysdate,
         v_empr_codi,
         v_desc);

      insert into audi_files_archivos
        (aufi_file_id, aufi_oci_file_id, aufi_esta, aufi_orig_tabl)
      values
        (v_file_id, v_desc, 'S', v_tipo);

    elsif v_file_clob is not null then

      v_file_id   := v_files_archivos_seq;
      l_file_clob := v_file_clob;
      -- Convert CLOB to BLOB for compression
      dbms_lob.createtemporary(l_file_blob, true);
      dbms_lob.converttoblob(l_file_blob,
                             l_file_clob,
                             dbms_lob.lobmaxsize,
                             l_dest_offset,
                             l_src_offset,
                             dbms_lob.default_csid,
                             l_lang_context,
                             l_warning);

      -- Compress the blob
      dbms_lob.createtemporary(l_compressed_blob, true);
      utl_compress.lz_compress(l_file_blob, l_compressed_blob);
      v_desc := v_desc || '.gz'; -- Adjusting file name to reflect compression
      --v_mime_type := 'application/gzip'; -- Updating MIME type

      dbms_cloud.put_object(credential_name => 'alarmas_file_access',
                            object_uri      => 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/' ||
                                               'p/1Ne2cl-zi5iu13gkEBHigHUisjE42RF2vduwlotyLHrvruZNUiSMoUcbsvY0-0sz/n/grcrplvrg8aa/b/files_alarmas/o/' ||
                                               v_desc,
                            contents        => l_compressed_blob);

      dbms_lob.freetemporary(l_file_blob);
      dbms_lob.freetemporary(l_compressed_blob);

      insert into files_archivos
        (file_id,
         file_desc,
         file_name,
         file_mime_type,
         file_created_by,
         file_created_on,
         file_empr_codi,
         file_desc_auto)
      values
        (v_files_archivos_seq,
         v_desc_arch,
         v_desc_arch,
         v_mime_type,
         fa_user,
         sysdate,
         v_empr_codi,
         v_desc);

      insert into audi_files_archivos
        (aufi_file_id, aufi_oci_file_id, aufi_esta, aufi_orig_tabl)
      values
        (v_file_id, v_desc, 'S', v_tipo);

    else

      v_file_id := v_files_archivos_seq;

      insert into files_archivos
        (file_id,
         file_desc,
         file_name,
         file_mime_type,
         file_created_by,
         file_created_on,
         file_empr_codi,
         file_desc_auto)
      values
        (v_files_archivos_seq,
         v_desc_arch,
         v_desc_arch,
         v_mime_type,
         fa_user,
         sysdate,
         v_empr_codi,
         v_desc);

      insert into audi_files_archivos
        (aufi_file_id, aufi_oci_file_id, aufi_esta, aufi_orig_tabl)
      values
        (v_file_id, v_desc, 'N', v_tipo);

      commit;

      raise e_file_null;
    end if;

    commit;

  exception
    when e_file_null then
      RAISE_APPLICATION_ERROR(-20010, 'Ningun archivo fue cargado');
    when others then
      v_file_id := null;
  end;

  procedure pp_put_file_full(v_file               in blob,
                             v_files_archivos_seq in number,
                             v_mime_type          in varchar2,
                             v_tipo               in varchar,
                             v_empr_codi          in number) is

    l_file      blob;
    v_desc      varchar2(500);
    v_empr_desc varchar2(500);
    v_exte      varchar2(500);

  begin

    select replace(replace(empr_desc, ' ', ''), '.', '')
      into v_empr_desc
      from come_empr
     where empr_codi = v_empr_codi;

    --l_file      := utl_raw.cast_to_raw(v_file);
    v_exte := substr(v_mime_type, instr(v_mime_type, '/') + 1);
    l_file := v_file;
    v_desc := v_empr_desc || '_' || v_tipo || '_' || v_files_archivos_seq || '.' ||
              v_exte;

    dbms_cloud.put_object(credential_name => 'alarmas_file_access',
                          object_uri      => 'https://objectstorage.sa-saopaulo-1.oraclecloud.com/' ||
                                             'p/1Ne2cl-zi5iu13gkEBHigHUisjE42RF2vduwlotyLHrvruZNUiSMoUcbsvY0-0sz/n/grcrplvrg8aa/b/files_alarmas/o/' ||
                                            --'p/1Ne2cl-zi5iu13gkEBHigHUisjE42RF2vduwlotyLHrvruZNUiSMoUcbsvY0-0sz/n/grcrplvrg8aa/b/files_alarmas/o/' ||
                                             v_desc,
                          contents        => l_file);

    insert into AUDI_FILES_ARCHIVOS
      (aufi_file_id, aufi_oci_file_id, aufi_esta)
    values
      (v_files_archivos_seq, v_desc, 'S');

  exception
    when others then
      insert into AUDI_FILES_ARCHIVOS
        (aufi_file_id, aufi_oci_file_id, aufi_esta)
      values
        (v_files_archivos_seq, v_desc, 'N');

  end;

  procedure pp_carg_file is

    cursor cDeta is
      select file_id,
             file_blob_content,
             file_mime_type,
             nvl(file_empr_codi, 1) file_empr_codi,
             file_created_on,
             'files_archivos' tipo
        from FILES_ARCHIVOS
       where trunc(file_created_on) <> '01/01/2024';

    cursor cDeta_factura_eletronica is
      select elfa_respuesta,
             elfa_fac_env,
             elfa_xml_cont,
             elfa_codi,
             'prueba' tipo
        from come_elec_fact
       where elfa_xml_cont is not null
         and elfa_codi = 230471;

    p_elfa_respuesta number;
    p_elfa_fac_env   number;
    --p_elfa_qr_code   number;
    p_elfa_xml_cont number;

  begin

    execute immediate 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YYYY''';

    /* MIGRACION DE FILES_ARCHIVOS
    for rec in cDeta loop

      begin
        pp_put_file(v_file               => rec.elfa_respuesta, --clob
                    v_files_archivos_seq => rec.file_id,
                    v_mime_type          => rec.file_mime_type,
                    v_tipo               => rec.tipo,
                    v_empr_codi          => rec.file_empr_codi);

        commit;

      end;
    end loop;*/

    for rec in cDeta_factura_eletronica loop
      begin
        --elfa_respuesta
        pack_file.pp_put_file_comp(v_file_clob => rec.elfa_respuesta, --clob
                               v_mime_type => 'application/json',
                               v_tipo      => rec.tipo,
                               v_empr_codi => 1,
                               v_file_id   => p_elfa_respuesta);
        --elfa_fac_env
        pack_file.pp_put_file_comp(v_file_clob => rec.elfa_fac_env, --clob
                               v_mime_type => 'application/json',
                               v_tipo      => rec.tipo,
                               v_empr_codi => 1,
                               v_file_id   => p_elfa_fac_env);
        --elfa_qr_code
        /*pack_file.pp_put_file(v_file_blob => rec.elfa_qr_code, --blob
        v_mime_type => 'image/bmp',
        v_tipo      => rec.tipo,
        v_empr_codi => 1,
        v_file_id   => p_elfa_qr_code);*/

        --elfa_xml_cont
        pack_file.pp_put_file_comp(v_file_clob => rec.elfa_xml_cont, --clob
                               v_mime_type => 'application/xml',
                               v_tipo      => rec.tipo,
                               v_empr_codi => 1,
                               v_file_id   => p_elfa_xml_cont);

        update come_elec_fact
           set elfa_resp_file_id     = p_elfa_respuesta,
               elfa_fac_envi_file_id = p_elfa_fac_env,
               elfa_xml_file_id      = p_elfa_xml_cont
         where elfa_codi = rec.elfa_codi;

      exception
        when others then
          null;
      end;
      commit;

    end loop;

  end pp_carg_file;

end pack_file;
