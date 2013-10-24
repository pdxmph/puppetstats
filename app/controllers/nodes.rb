Puppetstats::App.controllers :nodes do
  
  # I wouldn't count on any of this doing much right now. Still modeling reports via 
  # scripts and filling out methods
  
  get '/preview/:id' do 
    @node = Node.find(params[:id])
    path = "http://puppetlabs.com#{@node.path}"
    source = open(path).read
    Readability::Document.new(source, :tags => %w{div p strong em h3 h4 h2 ul li code pre br}).content
  end
  
  get '/recent' do 
    @nodes = Node.where('pub_date > ?', Date.today - 15.days).order("pub_date DESC")
    @report = Node.period_report(30)
    render 'nodes/recent'
  end
  
  get '/incomplete' do 
    @nodes = Node.incomplete_taxo.paginate(:page => params[:page], :per_page => 30)
    render 'nodes/incomplete'
  end
  
  put '/update/:id' do 
    @node = Node.find(params[:id]) 
    @node.attributes = {:taxo_funnel => params[:reclass_funnel],
                 :taxo_source => params[:reclass_source],
                 :taxo_theme => params[:reclass_theme]}
    
    if @node.save
      @first = Node.incomplete_taxo.first
      redirect "/nodes/#{@first.id}"
    else
      "Something didn't save"
    end
  end
    
  get :index do
    @nodes = Node.paginate(:page => params[:page], :per_page => 30).order("pub_date DESC")
    render 'nodes/index'
  end

  get ':id' do
    @node = Node.find_by_id(params[:id])
    render 'nodes/show'
  end

  get ':year/:month' do
    @nodes = Node.where('extract(month from pub_date) = ? AND extract(year from pub_date) = ?',params[:month],params[:year])
    render 'nodes/index'
  end

  get 'by_quarter/:year/:quarter' do 
    @nodes = Node.by_year(params[:year]).by_quarter(params[:quarter])
    render 'nodes/index'
  end

  get '/leaderboard/:year/:month' do
    @age = params["age"]
    @nodes = Node.where('extract(month from pub_date) = ? AND extract(year from pub_date) = ?',params[:month],params[:year]).sort! { |a,b| b.pageviews(@age) <=> a.pageviews(@age) }
    render 'nodes/leaderboard'
  end
  
 
end