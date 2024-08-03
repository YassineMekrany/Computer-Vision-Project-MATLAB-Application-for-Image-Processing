function varargout = boutoun(varargin)
% BOUTOUN M-file for boutoun.fig
%      BOUTOUN, by itself, creates a new BOUTOUN or raises the existing
%      singleton*.
%
%      H = BOUTOUN returns the handle to a new BOUTOUN or the handle to
%      the existing singleton*.
%
%      BOUTOUN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOUTOUN.M with the given input arguments.
%
%      BOUTOUN('Property','Value',...) creates a new BOUTOUN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before boutoun_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to boutoun_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help boutoun

% Last Modified by GUIDE v2.5 25-Mar-2002 12:19:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @boutoun_OpeningFcn, ...
                   'gui_OutputFcn',  @boutoun_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before boutoun is made visible.
function boutoun_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to boutoun (see VARARGIN)

% Choose default command line output for boutoun
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes boutoun wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = boutoun_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
