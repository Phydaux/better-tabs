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

        pane = atom.workspace.getActivePane()
        docs = pane.items

        activeItem = atom.workspace.getActivePaneItem()
        pathRepo = @_getRepo()
        for doc in docs
            repoStatus = pathRepo?.getPathStatus(doc.getPath?())

            itemTitle = doc.getTitle()
            itemGrammar = ''

            grammar = doc.getGrammar?()?.name
            if grammar
                if grammar is 'Null Grammar'
                    grammar = 'Plain Text'

                itemGrammar = "#{grammar}"

            liElm = @_addItem itemTitle, itemGrammar

            liElm.classList.add('icon')
            itemType = doc.constructor.toString().split('(')[0].substr 9
            switch itemType
                when 'ReleaseNotesView'
                    liElm.classList.add('icon-squirrel')
                when 'SettingsView'
                    liElm.classList.add('icon-tools')
                when 'ImageEditor'
                    liElm.classList.add('icon-file-media')
                when 'TextEditor'
                    liElm.classList.add('icon-file-text')
                when 'ResultsPaneView'
                    liElm.classList.add('icon-search')
                when 'DeprecationCopView'
                    liElm.classList.add('icon-alert')
                when 'MarkdownPreviewView'
                    liElm.classList.add('icon-markdown')
                when 'IncompatiblePackagesComponent'
                    liElm.classList.add('icon-package')
                else
                    liElm.classList.add('icon-primitive-dot')

            if doc.isModified?()
                liElm.classList.add('modified')

            if pathRepo?.isStatusModified(repoStatus)
                liElm.classList.add('status-modified')

            if pathRepo?.isStatusNew(repoStatus)
                liElm.classList.add('status-added')

            if repoStatus is 4
                liElm.classList.add('status-removed')

            if doc is activeItem
                liElm.classList.add('active')

            if doc.findMarkers?({class: "bookmark"})?.length
                liElm.classList.add('bookmarked')
        #getGrammar
        #getLongTitle
        #getTitle
        #getURI
        #isModified

    _addItem: (name, grammar) ->
        newLi = document.createElement('li')
        newLi.textContent = name

        if grammar
            newLi.innerHTML += "<span style='float: right'>#{grammar}</span>"

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
