class PeopleController < ApplicationController

  def index
    @people = Person.all
  end

  def new
    @person = Person.new
    @roles = Role.all
  end

  def create
    if request.post?
      person = Person.new(params[:person].merge(:roles => Role.find(params[:roles])))
      person.save
    end
    redirect_to people_path
  end

  def show
    @person = Person.find(params[:id])
  end

  def destroy
    Person.delete(params[:id])
    redirect_to people_path
  end

end
