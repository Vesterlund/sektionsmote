# frozen_string_literal: true

module Admin
  # Sets current agenda
  class CurrentAgendasController < Admin::BaseController
    authorize_resource(class: Agenda)

    def update
      @agenda = AgendaItem.find(params[:id])
      expire_fragment('agenda_startpage')
      @success = @agenda.update(status: :current)
    end

    def destroy
      @agenda = AgendaItem.find(params[:id])
      expire_fragment('agenda_startpage')
      @success = @agenda.update(status: :closed)
    end
  end
end
