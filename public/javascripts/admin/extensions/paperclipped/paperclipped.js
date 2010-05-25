var Asset = {};

Asset.Tabs = Behavior.create({
  onclick: function(e){
    e.stop();
    Asset.ChooseTab(this.element);
  }
});

// factored out so that it can be called in an ajax response

Asset.ChooseTab = function (element) {
  var pane = $(element.href.split('#')[1]);
  var panes = $('assets').select('.pane');
  
  var tabs = $('asset-tabs').select('.asset-tab.here');
  tabs.each(function(tab) {tab.removeClassName('here');});
  
  element.addClassName('here');;
  panes.each(function(pane) {Element.hide(pane);});
  Element.show($(pane));
}

Asset.ChooseTabByName = function (tabname) {
  var element = $('tab_' + tabname);
  Asset.ChooseTab(element);
}

// factored out so that it can be called after new page part creation

Asset.MakeDraggables = function () { 
  $$('div.asset').each(function(element){
    new Draggable(element, { revert: true });
    element.addClassName('move');
  });
}

Asset.DisableLinks = Behavior.create({
  onclick: function(e){
    e.stop();
  }
});

Asset.AddToPage = Behavior.create({
  onclick: function(e){
    e.stop();
    url = this.element.href;
    new Ajax.Updater('attachments', url, {
      asynchronous : true, 
      evalScripts  : true, 
      method       : 'get',
      onSuccess    : Asset.ChooseTabByName('page-attachments')
    });
    
  }
});

Asset.AddToBucket = Behavior.create({
  onclick: function(e){
    e.stop();
    url = this.element.href;
    new Ajax.Request(url, {
      onSuccess: function(response) {
        //TODO some sort of feedback. not an alert
      }
    });
  }
});

Asset.MakeDroppables = function () {
  $$('.textarea').each(function(box){
    if (!box.hasClassName('droppable') && !box.hasClassName('wymified')) {
      Droppables.add(box, {
        accept: 'asset',
        onDrop: function(element) {
          var link = element.select('a.bucket_link')[0];
          var asset_title = link.title;
          var asset_id = element.id.split('_').last();
          var classes = element.className.split(' ');
          var tag_type = classes[0];
          
          var tag = '<r:assets:' + tag_type + ' title="'+ asset_title +'" />';


          Form.Element.focus(box);
          if(!!document.selection){
            box.focus();
            var range = (box.range) ? box.range : document.selection.createRange();
            range.text = tag;
            range.select();
          }else if(!!box.setSelectionRange){
            var selection_start = box.selectionStart;
            box.value = box.value.substring(0,selection_start) + tag + box.value.substring(box.selectionEnd);
            box.setSelectionRange(selection_start + tag.length,selection_start + tag.length);
          }
          box.focus();
        }
      });      
      box.addClassName('droppable');
    }
  });
}

Asset.WaitingForm = Behavior.create({
  onsubmit: function(e){
    this.element.addClassName('waiting');
    return true;
  }
});

Asset.ResetForm = function (name) {
  var element = $('asset-upload');
  element.removeClassName('waiting');
  element.reset();
  
  ta = $$(".wymified");
  for (var i = 0; i < ta.length; i++){
    boot_wym(ta[i]);
  }
}

Asset.AddAsset = function (name) {
  element = $(name); 
  asset = element.select('.asset')[0];
  if (window.console && window.console.log) {
    console.log('inserted element is ', element);
    console.log('contained asset is ', asset);
  }
  if (asset) {
    new Draggable(asset, { revert: true });
  }
}

Event.addBehavior({
  '#asset-tabs a'     : Asset.Tabs,
  '#filesearchform a' : Asset.FileTypes,
  '#asset-upload'     : Asset.WaitingForm,
  'div.asset a'       : Asset.DisableLinks,
  'a.add_asset'       : Asset.AddToPage,
  '.add-to-bucket a'  : Asset.AddToBucket
});

// Stolen from the admin.js for Radiant, but for some reason it does not load. 
// When object is available, do function fn.
function when(obj, fn) {
  if (Object.isString(obj)) obj = /^[\w-]+$/.test(obj) ? $(obj) : $(document.body).down(obj);
  if (Object.isArray(obj) && !obj.length) return;
  if (obj) fn(obj);
}

document.observe("dom:loaded", function() {
  if($('page-attachments')) {
    Asset.ChooseTabByName('page-attachments');
    Asset.MakeDroppables();
    Asset.MakeDraggables();
  } else {
    Asset.ChooseTabByName('bucket');
    Asset.MakeDroppables();
    Asset.MakeDraggables();
  }
});