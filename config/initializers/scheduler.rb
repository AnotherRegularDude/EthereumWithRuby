require 'rufus-scheduler'

unless defined?(Rails::Console) || File.split($PROGRAM_NAME).last == 'rake'
  Rufus::Scheduler.singleton.every '5s' do
    RegistryImporter.call(
      AppContractHolder.instance.isbn_registry, 'RegistryChanged', BookEdition, UniversalBookEditionForm, 'bookEditions'
    )
  end
end
