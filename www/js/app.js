(function() {
  'use strict';

  var globals = typeof window === 'undefined' ? global : window;
  if (typeof globals.require === 'function') return;

  var modules = {};
  var cache = {};
  var has = ({}).hasOwnProperty;

  var aliases = {};

  var endsWith = function(str, suffix) {
    return str.indexOf(suffix, str.length - suffix.length) !== -1;
  };

  var unalias = function(alias, loaderPath) {
    var start = 0;
    if (loaderPath) {
      if (loaderPath.indexOf('components/' === 0)) {
        start = 'components/'.length;
      }
      if (loaderPath.indexOf('/', start) > 0) {
        loaderPath = loaderPath.substring(start, loaderPath.indexOf('/', start));
      }
    }
    var result = aliases[alias + '/index.js'] || aliases[loaderPath + '/deps/' + alias + '/index.js'];
    if (result) {
      return 'components/' + result.substring(0, result.length - '.js'.length);
    }
    return alias;
  };

  var expand = (function() {
    var reg = /^\.\.?(\/|$)/;
    return function(root, name) {
      var results = [], parts, part;
      parts = (reg.test(name) ? root + '/' + name : name).split('/');
      for (var i = 0, length = parts.length; i < length; i++) {
        part = parts[i];
        if (part === '..') {
          results.pop();
        } else if (part !== '.' && part !== '') {
          results.push(part);
        }
      }
      return results.join('/');
    };
  })();
  var dirname = function(path) {
    return path.split('/').slice(0, -1).join('/');
  };

  var localRequire = function(path) {
    return function(name) {
      var absolute = expand(dirname(path), name);
      return globals.require(absolute, path);
    };
  };

  var initModule = function(name, definition) {
    var module = {id: name, exports: {}};
    cache[name] = module;
    definition(module.exports, localRequire(name), module);
    return module.exports;
  };

  var require = function(name, loaderPath) {
    var path = expand(name, '.');
    if (loaderPath == null) loaderPath = '/';
    path = unalias(name, loaderPath);

    if (has.call(cache, path)) return cache[path].exports;
    if (has.call(modules, path)) return initModule(path, modules[path]);

    var dirIndex = expand(path, './index');
    if (has.call(cache, dirIndex)) return cache[dirIndex].exports;
    if (has.call(modules, dirIndex)) return initModule(dirIndex, modules[dirIndex]);

    throw new Error('Cannot find module "' + name + '" from '+ '"' + loaderPath + '"');
  };

  require.alias = function(from, to) {
    aliases[to] = from;
  };

  require.register = require.define = function(bundle, fn) {
    if (typeof bundle === 'object') {
      for (var key in bundle) {
        if (has.call(bundle, key)) {
          modules[key] = bundle[key];
        }
      }
    } else {
      modules[bundle] = fn;
    }
  };

  require.list = function() {
    var result = [];
    for (var item in modules) {
      if (has.call(modules, item)) {
        result.push(item);
      }
    }
    return result;
  };

  require.brunch = true;
  globals.require = require;
})();
require.register("application", function(exports, require, module) {
var Application, BrowseView, ChoicesSingleton, CollectionFormView, CollectionListView, DeleteBrowseView, JobCollection, JobElementFormView, JobListView, JobModel, JobView, PageView, app,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty,
  indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

ChoicesSingleton = require("models/choices");

JobModel = require("models/job");

JobCollection = require("models/job-collection");

PageView = require("views/page");

CollectionFormView = require("views/collection-form");

CollectionListView = require("views/collection-list");

JobElementFormView = require("views/job-element-form");

JobListView = require("views/job-list");

JobView = require("views/job");

BrowseView = require('views/browse');

DeleteBrowseView = require('views/delete-browse');

module.exports = Application = (function(superClass) {
  extend(Application, superClass);

  function Application() {
    this._validateComponent = bind(this._validateComponent, this);
    this._addComponent = bind(this._addComponent, this);
    this._saveJob = bind(this._saveJob, this);
    this._resetJob = bind(this._resetJob, this);
    this._promptEmail = bind(this._promptEmail, this);
    this._promptPdf = bind(this._promptPdf, this);
    this._generatePromptBody = bind(this._generatePromptBody, this);
    this._updateHeader = bind(this._updateHeader, this);
    this._updateCost = bind(this._updateCost, this);
    this._viewJob = bind(this._viewJob, this);
    this._readJob = bind(this._readJob, this);
    this._createJob = bind(this._createJob, this);
    return Application.__super__.constructor.apply(this, arguments);
  }

  Application.prototype._jobs = null;

  Application.prototype._current = null;

  Application.prototype._pages = null;

  Application.prototype._steps = {
    home: {
      prev: "home"
    },
    create: {
      next: "add.concrete"
    },
    concrete: {
      prev: "add.create",
      next: "add.labor"
    },
    labor: {
      prev: "add.concrete",
      next: "add.materials"
    },
    materials: {
      prev: "add.labor",
      next: "add.equipment"
    },
    equipment: {
      prev: "add.materials",
      next: "add.subcontractor"
    },
    subcontractor: {
      prev: "add.equipment",
      next: "add.save"
    },
    save: {
      prev: "add.subcontractor"
    }
  };

  Application.prototype.routes = {
    "": "home",
    "home": "home",
    "open": "open",
    "browse": "browse",
    "delete-browse": "deleteBrowse",
    "read.:id": "read",
    "add(.:routeType)": "add",
    "edit(.:routeType)": "edit",
    "delete-job.:id": "deleteJob",
    "delete-group.:group_id": "deleteGroup"
  };

  Application.prototype.initialize = function(opts) {
    console.log("Initializing Appstruction");
    this._jobs = new JobCollection(null, {
      model: JobModel,
      modelType: "job",
      url: "jobs"
    });
    this._jobs.fetch();
    this._createJob();
    this._bindEvents();
    return this;
  };

  Application.prototype.home = function() {
    console.log("Loading home page");
    this._createJob();
    this._pages = {};
    if (this._pages["home"] == null) {
      this._pages["home"] = new PageView({
        id: "home",
        title: "Concrete Estimator",
        text: {
          id: "start",
          content: ""
        }
      });
      this._setPage(this._pages["home"]);
    }
    return this._showPage(this._pages["home"]);
  };

  Application.prototype.browse = function() {
    console.log("Loading browse page");
    if (this._pages["browse"] == null) {
      this._pages["browse"] = new PageView({
        id: "browse",
        title: "Load an Estimate",
        subView: new BrowseView({
          routeType: 'browse'
        })
      });
      this._setPage(this._pages["browse"]);
    }
    return this._showPage(this._pages["browse"]);
  };

  Application.prototype.deleteBrowse = function() {
    console.log("Loading delete-browse page");
    if (this._pages["delete-browse"] == null) {
      this._pages["delete-browse"] = new PageView({
        id: "delete-browse",
        title: "Delete an Estimate",
        subView: new DeleteBrowseView({
          routeType: 'delete-browse'
        })
      });
      this._setPage(this._pages["delete-browse"]);
    }
    return this._showPage(this._pages["delete-browse"]);
  };

  Application.prototype.read = function(id) {
    var routeType;
    console.log("Loading job listing page");
    routeType = "read-" + id;
    if (this._pages[routeType] == null) {
      this._readJob(id);
      this._pages[routeType] = new PageView({
        title: this._current.attributes.job_name,
        subView: new JobView({
          model: this._current,
          routeType: 'read'
        })
      });
      this._setPage(this._pages[routeType]);
    }
    return this._showPage(this._pages[routeType]);
  };

  Application.prototype.add = function(routeType) {
    if (routeType == null) {
      routeType = "create";
    }
    console.log("Loading " + routeType + " component page");
    return this._viewJob(routeType);
  };

  Application.prototype.edit = function(routeType) {
    if (routeType == null) {
      routeType = 'create';
    }
    console.log("Editing " + routeType + " component page");
    return this._viewJob(routeType, 'edit');
  };

  Application.prototype.deleteJob = function(id, navigate_home) {
    if (navigate_home == null) {
      navigate_home = true;
    }
    console.log('Deleting job');
    this._readJob(id);
    ChoicesSingleton.removeJobGroup(this._current);
    ChoicesSingleton.save();
    return this._resetJob(navigate_home);
  };

  Application.prototype.deleteGroup = function(group_id) {
    var group_models, i, id, ids, len;
    console.log('Deleting group');
    group_models = this._jobs.byGroupId(group_id);
    ids = _.pluck(group_models, 'id');
    for (i = 0, len = ids.length; i < len; i++) {
      id = ids[i];
      this.deleteJob(id, false);
    }
    return this._navigate('home');
  };

  Application.prototype._setPage = function(page) {
    $("body").append(page.render().$el);
    return true;
  };

  Application.prototype._showPage = function(page) {
    $("section").hide();
    page.$el.show();
    return true;
  };

  Application.prototype._bindEvents = function() {
    console.log("Binding events");
    $(document).hammer().on("tap", "button.job.save", this._saveJob);
    $(document).hammer().on("tap", "button.ccma-navigate", this._navigateEvent);
    $(document).hammer().on("tap", "button.ccma-navigate", this._updateHeader);
    $(document).hammer().on("tap", "button.ccma-navigate", this._updateCost);
    $(document).hammer().on("tap", "button.add", this._validateComponent);
    $(document).hammer().on("tap", "button.job.reset", this._resetJob);
    $(document).hammer().on("change", ".field", this._updateCost);
    $(document).hammer().on("tap", ".header-help", this._showHelp);
    $(document).hammer().on("tap", ".field-help", this._showHelp);
    $(document).hammer().on("tap", ".header-email", this._promptEmail);
    $(document).hammer().on("tap", ".header-pdf", this._promptPdf);
    return true;
  };

  Application.prototype._navigateEvent = function(evt) {
    var path, pathNav;
    evt.preventDefault();
    path = $(evt.currentTarget).data("path");
    Backbone.history.navigate(path, true);
    $("nav button").removeClass("active");
    pathNav = path.split(".", 1);
    return $("nav button." + pathNav).addClass("active");
  };

  Application.prototype._navigate = function(path) {
    var pathNav;
    Backbone.history.navigate(path, true);
    $("nav button").removeClass("active");
    pathNav = path.split(".", 1);
    return $("nav button." + pathNav).addClass("active");
  };

  Application.prototype._createJob = function() {
    console.log("Creating new job");
    this._current = new JobModel;
    return this._current;
  };

  Application.prototype._readJob = function(id) {
    console.log("Reading job " + id);
    this._current = this._jobs.get(id);
    return this._current;
  };

  Application.prototype._viewJob = function(routeType, viewType) {
    var collection, view;
    if (routeType == null) {
      routeType = "create";
    }
    if (viewType == null) {
      viewType = "add";
    }
    console.log("Viewing job");
    if (this._pages[routeType] == null) {
      view = null;
      collection = null;
      if (indexOf.call(ChoicesSingleton.get('job_routes'), routeType) >= 0) {
        collection = this._current.get(routeType);
      }
      if (collection != null) {
        console.log("Creating " + routeType + " collection form view");
        view = new CollectionFormView({
          title: routeType,
          routeType: routeType,
          collection: collection,
          step: this._steps[routeType]
        });
      } else {
        console.log("Creating job element form view");
        if (routeType === 'create' || routeType === 'save') {
          view = new JobElementFormView({
            title: routeType,
            routeType: routeType,
            model: this._current,
            step: this._steps[routeType]
          });
        }
      }
      this._pages[routeType] = new PageView({
        id: routeType,
        title: "Job Builder",
        subView: view
      });
      if (viewType === 'add') {
        this._addComponent(routeType);
      }
      this._setPage(this._pages[routeType]);
    }
    return this._showPage(this._pages[routeType]);
  };

  Application.prototype._updateCost = function() {
    var cost;
    console.log("Recalculating job cost");
    if (this._current != null) {
      cost = this._current.calculate();
    }
    $('.subtotal').text(cost.toFixed(2));
    return this._current;
  };

  Application.prototype._updateHeader = function(currentRoute) {
    var allowedRoutes, headerEmail, headerHelp, headerJobName, headerPdf, headerText, headerTitle, help, routeType;
    if (currentRoute == null) {
      currentRoute = null;
    }
    console.log("Refreshing header");
    if (typeof currentRoute !== 'string') {
      currentRoute = null;
    }
    currentRoute = currentRoute || Backbone.history.fragment;
    if (currentRoute == null) {
      return;
    }
    allowedRoutes = ["add.concrete", "add.labor", "add.materials", "add.equipment", "add.subcontractor", "add.save", "edit.concrete", "edit.labor", "edit.materials", "edit.equipment", "edit.subcontractor"];
    headerJobName = $('div.header-job-name');
    headerTitle = $('div.header-title').find('h3');
    headerText = headerTitle.find('.header-text');
    headerHelp = headerTitle.find('.header-help');
    headerEmail = headerTitle.find('.header-email');
    headerPdf = headerTitle.find('.header-pdf');
    if (currentRoute.slice(0, 4) === 'read' || indexOf.call(allowedRoutes, currentRoute) >= 0) {
      headerJobName.find('h3').text(this._current.attributes.job_name);
      headerJobName.show();
      routeType = currentRoute.split('.');
      routeType = routeType[routeType.length - 1];
      if (indexOf.call(ChoicesSingleton.get('job_routes'), routeType) >= 0) {
        headerText.text(routeType);
      }
    } else {
      headerJobName.hide();
    }
    help = ChoicesSingleton.getHelp(routeType);
    if (help != null) {
      headerHelp.data('help', help);
      headerHelp.show();
    } else {
      headerHelp.hide();
    }
    if (currentRoute === 'add.save') {
      headerEmail.show();
      headerPdf.show();
    } else {
      headerEmail.hide();
      headerPdf.hide();
    }
    return this._current;
  };

  Application.prototype._showHelp = function(e) {
    return bootbox.alert($(e.currentTarget).data('help'));
  };

  Application.prototype._generatePromptBody = function() {
    var a, body, concrete, cost, equipment, group_name, i, item, item_text, j, job_type, k, l, labor, len, len1, len2, len3, len4, m, materials, profit_margin, ref, ref1, ref2, ref3, ref4, subcontractor, total_cost;
    a = this._current.attributes;
    job_type = ChoicesSingleton.getTextById('job_type_options', a.job_type);
    group_name = ChoicesSingleton.getTextById('group_name_options', a.group_id);
    cost = this._current.cost;
    if (isNaN(parseFloat(a.profit_margin)) || !isFinite(a.profit_margin)) {
      total_cost = cost;
      profit_margin = 0;
    } else {
      profit_margin = a.profit_margin;
      total_cost = cost + (cost * (a.profit_margin / 100));
    }
    concrete = "";
    ref = a.concrete.models;
    for (i = 0, len = ref.length; i < len; i++) {
      item = ref[i];
      item_text = item.overview().join('\n');
      concrete = "" + concrete + item_text + "\n\n";
    }
    labor = "";
    ref1 = a.labor.models;
    for (j = 0, len1 = ref1.length; j < len1; j++) {
      item = ref1[j];
      item_text = item.overview().join('\n');
      labor = "" + labor + item_text + "\n\n";
    }
    materials = "";
    ref2 = a.materials.models;
    for (k = 0, len2 = ref2.length; k < len2; k++) {
      item = ref2[k];
      item_text = item.overview().join('\n');
      materials = "" + materials + item_text + "\n\n";
    }
    equipment = "";
    ref3 = a.equipment.models;
    for (l = 0, len3 = ref3.length; l < len3; l++) {
      item = ref3[l];
      item_text = item.overview().join('\n');
      equipment = "" + equipment + item_text + "\n\n";
    }
    subcontractor = "";
    ref4 = a.subcontractor.models;
    for (m = 0, len4 = ref4.length; m < len4; m++) {
      item = ref4[m];
      item_text = item.overview().join('\n');
      subcontractor = "" + subcontractor + item_text + "\n\n";
    }
    body = "Group: " + group_name + "\nJob name: " + a.job_name + "\nJob type: " + job_type + "\n\nSubtotal: " + (cost.toFixed(2)) + "\nProfit margin: " + profit_margin + "%\nCost: " + (total_cost.toFixed(2)) + "\n\nConcrete:\n" + concrete + "\nLabor:\n" + labor + "\nMaterials:\n" + materials + "\nEquipment:\n" + equipment + "\nSubcontractor:\n" + subcontractor;
    return body;
  };

  Application.prototype._promptPdf = function(e) {
    var body, doc, filename;
    filename = this._current.attributes.job_name + ".pdf";
    body = this._generatePromptBody();
    doc = new jsPDF();
    doc.setFontSize(22);
    doc.setFontType('bold');
    doc.text(20, 20, "Appstruction Proposal");
    doc.setFontSize(14);
    doc.setFontType('normal');
    doc.text(20, 30, body);
    return doc.save(filename);
  };

  Application.prototype._promptEmail = function(e) {
    var body, subject;
    subject = "Appstruction proposal";
    body = this._generatePromptBody();
    body = encodeURIComponent(body);
    return window.location.href = "mailto:?subject=" + subject + "&body=" + body;
  };

  Application.prototype._resetJob = function() {
    console.log("Reseting job");
    this._current.destroy();
    this._navigate('home');
    return true;
  };

  Application.prototype._saveJob = function(evt) {
    console.log("Saving job");
    if (this._current.isValid()) {
      this._current.save();
      ChoicesSingleton.addJobGroup(this._current);
      ChoicesSingleton.save();
      this._jobs.add(this._current);
      console.log(JSON.stringify(this._current.toJSON()));
      return true;
    } else {
      alert(this._current.validationError);
      return false;
    }
  };

  Application.prototype._addComponent = function(routeType) {
    if (indexOf.call(ChoicesSingleton.get('job_routes'), routeType) >= 0) {
      this._current.get(routeType).add({});
    }
    $('select').select2({
      allowClear: true,
      minimumResultsForSearch: 6
    });
    $("input[type=number]").keyup(function() {
      var new_val, template, val;
      val = $(this).val();
      if (val.lastIndexOf('.', 0) === 0) {
        template = '.0000000000';
        if (val === template.substring(0, val.length)) {
          return;
        }
        new_val = '0' + val;
        return $(this).val(new_val);
      }
    });
    return true;
  };

  Application.prototype._validateComponent = function(evt) {
    var last, routeType;
    evt.preventDefault();
    routeType = $(evt.currentTarget).data('type');
    console.log("Validating " + routeType);
    last = this._current.get(routeType).last();
    if (last.isValid()) {
      console.log("Adding " + routeType + " to active job");
      this._addComponent(routeType);
    } else {
      alert(last.validationError);
    }
    return last;
  };

  return Application;

})(Backbone.Router);

module.exports = app = new Application;
});

;require.register("devel", function(exports, require, module) {
var application;

application = require("application");

$(function() {
  return Backbone.history.start();
});
});

;require.register("init", function(exports, require, module) {
var CordovaApp, app, application, cordovaClass;

application = require("application");

cordovaClass = CordovaApp = (function() {
  function CordovaApp() {}

  CordovaApp.prototype.initialize = function() {
    this.bindEvents();
    return true;
  };

  CordovaApp.prototype.bindEvents = function() {
    document.addEventListener('deviceready', this.onDeviceReady, false);
    return true;
  };

  CordovaApp.prototype.onDeviceReady = function() {
    Backbone.history.start();
    return app.receivedEvent('deviceready');
  };

  CordovaApp.prototype.receivedEvent = function(id) {
    var listeningElement, parentElement, receivedElement;
    parentElement = document.getElementById(id);
    listeningElement = parentElement.querySelector('.listening');
    receivedElement = parentElement.querySelector('.received');
    listeningElement.setAttribute('style', 'display:none;');
    receivedElement.setAttribute('style', 'display:block;');
    console.log('Received Event: ' + id);
    return true;
  };

  return CordovaApp;

})();

app = new cordovaClass;

app.initialize();
});

;
//# sourceMappingURL=app.js.map