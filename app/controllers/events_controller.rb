class EventsController < ApplicationController

  def show
    @event = Event.find(params[:id])
  end

  def remove_person
    EventPersonRole.delete_all(:event_id => params[:event_id], :person_id => params[:person_id])
    redirect_to event_path(params[:event_id])
  end
end
