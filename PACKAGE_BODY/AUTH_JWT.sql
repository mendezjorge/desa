
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."AUTH_JWT" is
  ---+++ comentario de prueba nuevo
  procedure pp_generar_token(i_user_id in number,
                             i_time    in number,
                             o_status  out varchar2,
                             o_message out varchar2,
                             o_token   out clob) is
  
    v_token varchar2(3000);
  
  begin
  
    v_token := apex_jwt.encode(p_iss           => 'sqlplus',
                               p_sub           => 'api',
                               p_aud           => 'apex',
                               p_iat_ts        => sysdate, --hora de token generado
                               p_exp_sec       => i_time, -- validez del token 1dia= 86400; 1min= 60 para minuto;
                               p_other_claims  => '"id": ' ||
                                                  apex_json.stringify(i_user_id),
                               p_signature_key => sys.UTL_RAW.cast_to_raw('ikjsdjv89j9j23hoakdjHGHg788*^%^75sdhsddgfhghfgh'));
  
    o_status  := 200;
    o_message := 'Success';
    o_token   := v_token;

  exception
    when others then
      o_status  := 401;
      o_message := '' || sqlerrm;
  end;

  procedure pp_decodificar_token(i_token   in clob, -- varchar2,
                                 o_id      out varchar2,
                                 o_status  out number,
                                 o_message out varchar2) is
  
    l_token  apex_jwt.t_token;
    v_exp    varchar2(100);
    v_iss    varchar2(16);
    v_sub    varchar2(16);
    v_aud    varchar2(16);
    time_act number;
  begin
  
    l_token := apex_jwt.decode(p_value         => i_token,
                               p_signature_key => sys.UTL_RAW.cast_to_raw('ikjsdjv89j9j23hoakdjHGHg788*^%^75sdhsddgfhghfgh'));
    apex_json.parse(l_token.payload);

    -- validar token
    v_iss := apex_json.get_varchar2('iss');
  
    if v_iss <> 'sqlplus' then
      o_id      := null;
      o_status  := 401;
      o_message := 'Token corrupto';
      return;
    end if;
  
    v_sub := apex_json.get_varchar2('sub');
    if v_sub <> 'api' then
      o_id      := null;
      o_status  := 401;
      o_message := 'Token corrupto';
      return;
    end if;
  
    v_aud := apex_json.get_varchar2('aud');
    if v_aud <> 'apex' then
      o_id      := null;
      o_status  := 401;
      o_message := 'Token corrupto';
      return;
    end if;
  
    select (v_expire - sysdate) * 60 * 60 * 24
      into time_act
      from (select to_date('01-JAN-1970', 'dd-mon-yyyy') +
                   (apex_json.get_varchar2('exp') / 60 / 60 / 24) v_expire --se hace esta conversion porque el a?o esta en centurias
              from dual);
  
    select to_date('01-JAN-1970', 'dd-mon-yyyy') +
           (apex_json.get_varchar2('exp') / 60 / 60 / 24) v_expire --se hace esta conversion porque el a?o esta en centurias
      into v_exp
      from dual;
  
  
    v_exp := apex_json.get_varchar2('exp');
  --este if se agrego para que pueda pasar el token de los servicio que no necesitan temporalidad 13/09/2023 juan, alberto y orlando
    if v_exp is null then
      o_id      := apex_json.get_varchar2('id');
      o_message := 'Success';
      o_status  := 200;
    else
      if time_act > 0 then
        o_id      := apex_json.get_varchar2('id');
        o_message := 'Success';
        o_status  := 200;
      else
        o_id      := null;
        o_status  := 401;
        o_message := 'Error token expire; ';
      end if;
    end if;
  
  exception
    when others then
      o_status  := 401;
      o_message := '' || sqlerrm;
  end;

end auth_jwt;
