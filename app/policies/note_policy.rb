class NotePolicy < ApplicationPolicy
  def new?
    if record.project.owner == user 
      return true
    end
    up = find_user_project
    user.admin? || (up.collaborator_id == user.id && up.permission == "edit")
  end

  def create?
    if record.project.owner == user 
      return true
    end
    up = find_user_project
    user.admin? || (up.collaborator_id == user.id && up.permission == "edit")
  end

  def show?
    if record.project.owner == user 
      return true
    end
    up = find_user_project
    user.admin? || record.user == user || !up.nil?
  end

  def edit?
    if record.project.owner == user 
      return true
    end
    up = find_user_project
    user.admin? || record.user == user
  end

  def update?
    if record.project.owner == user 
      return true
    end
    up = find_user_project
    user.admin? || record.user == user 
  end

  def destroy?
    if record.project.owner == user 
      return true
    end
    user.admin? || record.user == user
  end
end