class ScriptsController < ApplicationController

  nestable_by :user_id => :creator_id

  def run
    if find_record
      if params[:uri].blank?
        redirect_to run_script_path(:id => @script.id, :uri => @script.base_uri)
      else
        uri = params[:uri].join('/').start_with('http://')
        html = ScriptExecutor.go uri, YAML.load(@script.content), "scripts/#{@script.id}/run"

        log "running Script<#{@script.id}>:#{@script.base_uri} on #{uri}"
        render :text => html
      end
    end
  end

end
