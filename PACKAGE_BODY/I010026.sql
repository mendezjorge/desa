
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SKN"."I010026" is

   procedure pp_actu_regi (i_indi          in varchar2,
                           i_para_desc     in varchar2,
                           i_para_valo     in varchar2,
                           i_para_nomb     in varchar2,
                           u_para_nomb     in varchar2, 
                           u_para_valo     in varchar2)is

   begin   
    
        if i_indi = 'N' then   
         
          insert into come_para
            (para_nomb, para_valo, para_desc, para_base, para_user_regi, para_fech_regi)
          values
            (i_para_nomb, i_para_valo, i_para_desc, pack_repl.fa_devu_codi_base, gen_user, sysdate);
          
        elsif i_indi = 'U' then
             
          update come_para
             set para_nomb = i_para_nomb,
                 para_valo = i_para_valo,
                 para_desc = i_para_desc,
                 para_user_modi = gen_user,
                 para_fech_modi = sysdate
           where para_nomb = u_para_nomb
             and para_valo = u_para_valo;
           
        end if;
   
    exception 
      when others then 
        raise_application_error(-20010, 'Error el momento de actualizar');
    end pp_actu_regi;

end I010026;
