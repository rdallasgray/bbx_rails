module Bbx
  module Controller
    class RolesController < Base
      before_filter :except => [:index, :show, :new] do
        authenticate_with_privilege_level :admin
      end
      before_filter :only => [:index, :show, :new] do
        authenticate_with_privilege_level :staff
      end
    end
  end
end

