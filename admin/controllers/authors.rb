Puppetstats::Admin.controllers :authors do
  get :index do
    @title = "Authors"
    @authors = Author.all
    render 'authors/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'author')
    @author = Author.new
    render 'authors/new'
  end

  post :create do
    @author = Author.new(params[:author])
    if @author.save
      @title = pat(:create_title, :model => "author #{@author.id}")
      flash[:success] = pat(:create_success, :model => 'Author')
      params[:save_and_continue] ? redirect(url(:authors, :index)) : redirect(url(:authors, :edit, :id => @author.id))
    else
      @title = pat(:create_title, :model => 'author')
      flash.now[:error] = pat(:create_error, :model => 'author')
      render 'authors/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "author #{params[:id]}")
    @author = Author.find(params[:id])
    if @author
      render 'authors/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'author', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "author #{params[:id]}")
    @author = Author.find(params[:id])
    if @author
      if @author.update_attributes(params[:author])
        flash[:success] = pat(:update_success, :model => 'Author', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:authors, :index)) :
          redirect(url(:authors, :edit, :id => @author.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'author')
        render 'authors/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'author', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Authors"
    author = Author.find(params[:id])
    if author
      if author.destroy
        flash[:success] = pat(:delete_success, :model => 'Author', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'author')
      end
      redirect url(:authors, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'author', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Authors"
    unless params[:author_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'author')
      redirect(url(:authors, :index))
    end
    ids = params[:author_ids].split(',').map(&:strip)
    authors = Author.find(ids)
    
    if Author.destroy authors
    
      flash[:success] = pat(:destroy_many_success, :model => 'Authors', :ids => "#{ids.to_sentence}")
    end
    redirect url(:authors, :index)
  end
end
