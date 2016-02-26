require_relative 'demo_helper'

conf_obj = LbnSecrets.new()
CONF = conf_obj.conf
STORAGE_ACC_SERVICE = Azure::Armrest::StorageAccountService.new(CONF)

def list_menu
  puts '-----------------------------------'
  puts 'sa - Info Storage accounts'
  puts 'l - list blobs'
  puts 'ls - list blobs snap dates'
  puts 'cs - create a snapshot for a blob'
  puts 'ds - delete a snapshot for a blob'
end

def info_sa
  print_code "
  code:
    sas = Azure::Armrest::StorageAccountService.new(CONF)
    sas.list
  "
  sas = Azure::Armrest::StorageAccountService.new(CONF)
  pp sas.list
end

def list_blobs
  print_code "
  code:
    storage_acc = STORAGE_ACC_SERVICE.get('sdlab1343')
    key = STORAGE_ACC_SERVICE.list_account_keys(storage_acc.name)['key1']
    container = 'vhds'

    blob_list = storage_acc.blobs(container = container, key = key,
                                  include_snapshot = true)
  "
  storage_acc = STORAGE_ACC_SERVICE.get('sdlab1343')
  key = STORAGE_ACC_SERVICE.list_account_keys(storage_acc.name)['key1']
  container = 'vhds'
  blob_list = storage_acc.blobs(container = container, key = key,
                                include_snapshot = true)
  blob_list.each do |blob|
    pp blob
  end
end

def list_blobs_snap_dates
  print_code "
  code:
    storage_acc = STORAGE_ACC_SERVICE.get('sdlab1343')
    key = STORAGE_ACC_SERVICE.list_account_keys(storage_acc.name)['key1']
    container = 'vhds'

    blob_list = storage_acc.blobs(container = container, key = key,
                                  include_snapshot = true)
  "
  storage_acc = STORAGE_ACC_SERVICE.get('sdlab1343')
  key = STORAGE_ACC_SERVICE.list_account_keys(storage_acc.name)['key1']
  container = 'vhds'
  blob_list = storage_acc.blobs(container = container, key = key,
                                include_snapshot = true)
  blob_list.each do |blob|
    if blob.class == Azure::Armrest::StorageAccount::BlobSnapshot
      pp "#{blob.name} -- snap date : #{blob.snapshot}"
    end
  end
end

def create_snapshot
  print_code "
  code:
    storage_acc = STORAGE_ACC_SERVICE.get('sdlab1343')
    key = STORAGE_ACC_SERVICE.list_account_keys(storage_acc.name)['key1']
    container = 'vhds'

    blob_snap = create_blob_snapshot(container = container,
                                     blob = 'testSDnewblob.vhd',
                                     key = key)
  "

  storage_acc = STORAGE_ACC_SERVICE.get('sdlab1343')
  key = STORAGE_ACC_SERVICE.list_account_keys(storage_acc.name)['key1']
  container = 'vhds'
  blob_snap = storage_acc.create_blob_snapshot(container = container,
                                   blob = 'testSDnewblob.vhd',
                                   key = key)
  pp blob_snap
end

def delete_snapshot
  print_code "
  code:
    storage_acc = STORAGE_ACC_SERVICE.get('sdlab1343')
    key = STORAGE_ACC_SERVICE.list_account_keys(storage_acc.name)['key1']
    container = 'vhds'
    snapshot = '2016-02-26T11:37:27.0195486Z'

    res = storage_acc.delete_blob(container = container,
                                  blob = 'testSDnewblob.vhd',
                                  key = key,
                                  date: snapshot)
  "

  storage_acc = STORAGE_ACC_SERVICE.get('sdlab1343')
  key = STORAGE_ACC_SERVICE.list_account_keys(storage_acc.name)['key1']
  container = 'vhds'
  snapshot = '2016-02-26T11:37:27.0195486Z'

  res = storage_acc.delete_blob(container = container,
                                blob = 'testSDnewblob.vhd',
                                key = key,
                                date: snapshot)
  pp res
end



def print_banner
  puts "
                  _      __ ______
    ___ ___  ____(_)__  / /<  /_  |
   (_-</ _ \\/ __/ / _ \\/ __/ / __/
  /___/ .__/_/ /_/_//_/\\__/_/____/
     /_/
  ".red
  puts "                     --Alexandre 'Fantastic LEad DEv' Lamandé".green
end


#Main
print_banner

list_menu
command = gets.chomp
while command != 'q' do
  case command
  when 'sa'
    info_sa
  when 'l'
    list_blobs
  when 'cs'
    create_snapshot
  when 'ds'
    delete_snapshot
  when 'ls'
    list_blobs_snap_dates
  else
    puts 'i don\'t know this action'
  end

  list_menu
  command = gets.chomp
end
