class ItemsController < ApplicationController
    before_action :find_item, only: [:show, :update, :edit, :destroy]
    before_action :own_item, only: [:show, :edit, :update, :destroy]
    before_action :authenticate_user!
    
    def index
        if user_signed_in?
            @items= Item.where(:user_id => current_user.id).order("created_at DESC")
        end
    end
    
    def show 
        
    end
    def new 
        @item=current_user.items.build
    end
    
    def create
        @item=current_user.items.build(items_params)
        if @item.save
            redirect_to root_path 
        else
            render 'new'
        end
    end
    
    def edit 
    end
    
    def update 
        if @item.update(items_params)
            redirect_to item_path(@item)
        else
            render 'edit'
        end
        
    end
    
    def destroy 
        @item.destroy
        redirect_to root_path
    end
    
    def complete
         @item=Item.find(params[:id])
         @item.update_attribute(:completed_at, Time.now)
         redirect_to root_path
    end
    
    private 
    
    def items_params
        params.require(:item).permit(:title, :description)
    end
    
    def find_item
        @item=Item.find(params[:id])
    end
    
    def own_item
        unless current_user == @item.user
            flash[:alert] = "You cannot view this item"
            redirect_to root_path
        end
    end
    
end
