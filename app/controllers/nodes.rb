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

  get ':year/:month' do
    @nodes = Node.where('extract(month from pub_date) = ? AND extract(year from pub_date) = ?',params[:month],params[:year])
    render 'nodes/index'
  end

  get '/leaderboard/:year/:month' do
    @age = params["age"]
    @nodes = Node.where('extract(month from pub_date) = ? AND extract(year from pub_date) = ?',params[:month],params[:year]).sort! { |a,b| b.pageviews(@age) <=> a.pageviews(@age) }
    render 'nodes/leaderboard'
  end
  
  get 'fix/no_funnel' do |n|
    @nodes = Node.no_funnel
    render 'nodes/index'
  end



end