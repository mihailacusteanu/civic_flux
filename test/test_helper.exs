{:ok, _} = Application.ensure_all_started(:eventstore)
{:ok, _} = Application.ensure_all_started(:civic_flux)

ExUnit.start()
