module.exports =
class BetterTabsView
    constructor: (serializedState) ->
        # Create root element
        @element = document.createElement('div')
        @element.classList.add('better-tabs')

        # Create message element
        message = document.createElement('div')
        @ulEl = document.createElement('ul')
        # message.textContent = "The BetterTabs package is Alive! It's ALIVE!"
        message.classList.add('message')
        message.appendChild(@ulEl)
        @element.appendChild(message)
        @_createList()

    # Returns an object that can be retrieved when package is activated
    serialize: ->

    # Tear down any state and detach
    destroy: ->
        @element.remove()

    getElement: ->
        @element

    _createList: ->
        @_removeItems()

        docs = atom.workspace.getPaneItems()
        activeItem = atom.workspace.getActivePaneItem()
        pathRepo = @_getRepo()
        for doc in docs
            repoStatus = pathRepo.getPathStatus(doc.getPath?())
            # console.log doc.getTitle()
            # @_addItem 'test'
            liElm = @_addItem "#{doc.getTitle()} - #{doc.getGrammar?()?.name}"
            # console.log doc.getGrammar?()
            # console.log "doc.getGrammar? #{doc.getGrammar?} #{doc.getGrammar?()}" asdasda
            # console.log "#{doc.getTitle()} doc.isModified? #{doc.isModified?()}"
            if doc.isModified?()
                liElm.classList.add('modified')

            if pathRepo.isStatusModified(repoStatus)
                liElm.classList.add('status-modified')

            if pathRepo.isStatusNew(repoStatus)
                liElm.classList.add('status-new')

            if doc is activeItem
                liElm.classList.add('active')
        #getGrammar
        #getLongTitle
        #getTitle
        #getURI
        #isModified

    _addItem: (name) ->
        newLi = document.createElement('li')
        newLi.textContent = name
        @ulEl.appendChild(newLi)
        return newLi

    _removeItems: ->
        while @ulEl.firstChild
            @ulEl.removeChild @ulEl.firstChild

    # From: https://github.com/atom/tree-view/blob/master/lib/helpers.coffee
    # _repoForPath: (goalPath) ->
    #     for projectPath, i in atom.project.getPaths()
    #       if goalPath is projectPath or goalPath.indexOf(projectPath + require('path').sep) is 0
    #         return atom.project.getRepositories()[i]
    #     null

    _getRepo: ->
        atom.project.getRepositories()[0]
