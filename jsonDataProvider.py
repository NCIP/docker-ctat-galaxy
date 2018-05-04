class JsonDataProvider( base.DataProvider ):
    def __init__( self, dataset, **kwargs ):
        self.dataset = json.loads( "".join( dataset.readlines() ))
