
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010270" is

  PROCEDURE pp_encripta_pass(P_pass in varchar2, p_user_codi in varchar2) IS
    v_spass varchar2(32);
    v_upass varchar2(40);
  BEGIN
    pa_encripta_pass(p_pass, v_spass, v_upass);
    update segu_user
       set USER_SPASS = v_spass, user_upass = v_upass
     where user_codi = p_user_codi;
    commit;
  END;

  -----------------------------------------------------------------------------------------------------------

  PROCEDURE PP_ACTUALIZAR_REGISTRO(p_indi_oper in varchar2,
                                   p_USU_PASS  in varchar2,
                                   p_PASS2     in varchar2,
                                   p_user_codi in varchar2) IS
    v_user          varchar2(20);
    v_pass          varchar2(20) := p_pass2;
    v_pass_apex     varchar2(100); -- variable para almacenar la contrase?a encriptada
    p_indi_apex     varchar2(100);
    p_indi_app_movi varchar(100);
    p_usu_login     varchar2(100);

  BEGIN

    select user_login into p_usu_login from segu_user
         where user_codi=p_user_codi;

    v_user:=p_usu_login;

    p_indi_apex     := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_apex')));
    p_indi_app_movi := rtrim(ltrim(general_skn.fl_busca_parametro('p_indi_app_movi')));

    if p_indi_oper = '1' then

      if p_USU_PASS <> p_PASS2 THEN
        raise_application_error(-20001, 'Vuelva a Confirmar Contrasenha');
      end if;

      /*IF FP_CONFIRMAR_REG('Esta seguro que desea cambiar la contrase?a?') =
      'CONFIRMAR' THEN*/
      --pl_mm('paso 1');

      PA_EJECUTA_DDL('ALTER USER ' || v_USER || ' IDENTIFIED BY ' ||
                     v_PASS);

      if nvl(p_indi_app_movi, 'N') = 'S' then
        pp_encripta_pass(p_usu_pass,p_user_codi);
      end if;

      -- actulizar la tabla como_segu para encriptar la contrase?a

      if nvl(p_indi_apex, 'N') = 'S' then
        v_pass_apex := my_hash(p_usu_login, p_usu_pass);

        update segu_user
           set user_pass = v_pass_apex --actualizacion en la tabla segu_user
         where user_login = p_usu_login;

        commit;
      end if;
      apex_application.g_print_success_message := 'La Contrasenha se cambio con exito';
      --:GLOBAL.CERRAR_FORM := 'SI';

      /*END IF;*/

    elsif p_indi_oper = '2' then
      update segu_user
         set user_indi_bloq = 'N'
       where user_login = p_usu_login;

      PA_EJECUTA_DDL('ALTER USER ' || v_USER || ' account unlock');
      apex_application.g_print_success_message := 'El usuario se desbloqueo con  exito!';

    elsif p_indi_oper = '3' then
      ---pl_mm(p_usu_login||'  v_USER:'||v_USER);

      update segu_user
         set user_indi_bloq = 'S'
       where user_login = p_usu_login;

      PA_EJECUTA_DDL('ALTER USER ' || upper(p_usu_login) ||
                     ' account lock');

      apex_application.g_print_success_message := 'El usuario se bloqueo con  exito!';
    end if;

  END;

end I010270;
