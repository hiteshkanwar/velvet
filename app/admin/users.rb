ActiveAdmin.register User do

form do |f|
      f.inputs "Details" do
        f.input :block , as: :radio
      end
      f.actions
    end
end
