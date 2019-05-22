%w{
  postgresql-devel
  postgresql-server
}.each do |name|
  package name do
    user 'root'
  end
end

execute 'postgresql-setup initdb' do
  user 'root'
  command <<-EOF
    postgresql-setup initdb
    touch /var/lib/pgsql/data/INITIALIZED
  EOF
  not_if 'test -e /var/lib/pgsql/data/INITIALIZED'
end

service 'postgresql' do
  user 'root'
  action [:enable]
end

template '/var/lib/pgsql/data/pg_hba.conf' do
  user 'root'
  owner 'postgres'
  group 'postgres'
  mode '600'
end

service 'postgresql' do
  user 'root'
  subscribes :restart, 'template[/var/lib/pgsql/data/pg_hba.conf]'
  action :nothing
end
