class ScriptsController < ApplicationController

  nestable_by :user_id => :creator_id

  def run
    if find_record
      uri = params[:uri].join('/').start_with('http://')

      log "running Script<#{@script.id}>:#{@script.base_uri} on #{uri}"

      # hax
      ScriptExecutor.go uri, YAML.load(@script.content), "scripts/#{@script.id}"
    end
  end

end
