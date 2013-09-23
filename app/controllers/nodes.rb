Puppetstats::App.controllers :nodes do
  
  # get :index, :map => '/foo/bar' do
  #   session[:foo] = 'bar'
  #   render 'index'
  # end

  # get :sample, :map => '/sample/url', :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   'Maps to url '/foo/#{params[:id]}''
  # end

  # get '/example' do
  #   'Hello world!'
  # end
  
  get :index do
    @nodes = Node.all(:order => 'pub_date desc')
    render 'nodes/index'
  end

  get :node, :with => :id do
    @node = Node.find_by_id(params[:id])
    render 'nodes/show'
  end

  get '/nodes/:year/:month' do |n|
    @nodes = Node.by_ym(params[:year],params[:month])
    render 'nodes/index'
  end
  
  get '/nodes/fix/no_funnel' do |n|
    @nodes = Node.no_funnel
    render 'nodes/index'
  end
end