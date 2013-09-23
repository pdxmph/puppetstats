Puppetstats::Admin.controllers :nodes do
  get :index do
    @title = "Nodes"
    @nodes = Node.all
    render 'nodes/index'
  end

  get :new do
    @title = pat(:new_title, :model => 'node')
    @node = Node.new
    render 'nodes/new'
  end

  post :create do
    @node = Node.new(params[:node])
    if @node.save
      @title = pat(:create_title, :model => "node #{@node.id}")
      flash[:success] = pat(:create_success, :model => 'Node')
      params[:save_and_continue] ? redirect(url(:nodes, :index)) : redirect(url(:nodes, :edit, :id => @node.id))
    else
      @title = pat(:create_title, :model => 'node')
      flash.now[:error] = pat(:create_error, :model => 'node')
      render 'nodes/new'
    end
  end

  get :edit, :with => :id do
    @title = pat(:edit_title, :model => "node #{params[:id]}")
    @node = Node.find(params[:id])
    if @node
      render 'nodes/edit'
    else
      flash[:warning] = pat(:create_error, :model => 'node', :id => "#{params[:id]}")
      halt 404
    end
  end

  put :update, :with => :id do
    @title = pat(:update_title, :model => "node #{params[:id]}")
    @node = Node.find(params[:id])
    if @node
      if @node.update_attributes(params[:node])
        flash[:success] = pat(:update_success, :model => 'Node', :id =>  "#{params[:id]}")
        params[:save_and_continue] ?
          redirect(url(:nodes, :index)) :
          redirect(url(:nodes, :edit, :id => @node.id))
      else
        flash.now[:error] = pat(:update_error, :model => 'node')
        render 'nodes/edit'
      end
    else
      flash[:warning] = pat(:update_warning, :model => 'node', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy, :with => :id do
    @title = "Nodes"
    node = Node.find(params[:id])
    if node
      if node.destroy
        flash[:success] = pat(:delete_success, :model => 'Node', :id => "#{params[:id]}")
      else
        flash[:error] = pat(:delete_error, :model => 'node')
      end
      redirect url(:nodes, :index)
    else
      flash[:warning] = pat(:delete_warning, :model => 'node', :id => "#{params[:id]}")
      halt 404
    end
  end

  delete :destroy_many do
    @title = "Nodes"
    unless params[:node_ids]
      flash[:error] = pat(:destroy_many_error, :model => 'node')
      redirect(url(:nodes, :index))
    end
    ids = params[:node_ids].split(',').map(&:strip)
    nodes = Node.find(ids)
    
    if Node.destroy nodes
    
      flash[:success] = pat(:destroy_many_success, :model => 'Nodes', :ids => "#{ids.to_sentence}")
    end
    redirect url(:nodes, :index)
  end
end
