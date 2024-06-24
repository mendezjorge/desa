
  CREATE OR REPLACE EDITIONABLE PROCEDURE "SKN"."PA_SEND_GITHUB_FILE" (i_file_path         in varchar2,
                                                i_file_content_blob in blob,
                                                i_commit_message    in clob) is
  l_repo_handle clob;
begin
  l_repo_handle := dbms_cloud_repo.init_github_repo(credential_name => 'GITHUB_CRED_DESA',
                                                    repo_name       => 'desa',
                                                    owner           => 'mendezjorge');

 --- modificado
  -- usa dbms_cloud para realizar el commit en github
  dbms_cloud_repo.put_file(repo           => l_repo_handle,
                           file_path      => i_file_path,
                           contents       => i_file_content_blob,
                           commit_details => i_commit_message);
exception
  when others then
    null;
end;
