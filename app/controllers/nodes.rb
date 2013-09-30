Puppetstats::App.controllers :nodes do
  
  # I wouldn't count on any of this doing much right now. Still modeling reports via 
  # scripts and filling out methods
  
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
  
  get 'fix/funnel' do 
    @nodes = Node.no_funnel
    render 'nodes/index'
  end

  get 'fix/theme' do 
    @nodes = Node.no_theme
    render 'nodes/index'
  end

  get 'fix/source' do 
    @nodes = Node.no_source
    render 'nodes/index'
  end

  get 'fix/type' do 
    @nodes = Node.no_type
    render 'nodes/index'
  end


end