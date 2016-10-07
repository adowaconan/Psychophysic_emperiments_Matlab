function varargout = nyquistsim(varargin)
% NYQUISTSIM MATLAB code for nyquistsim.fig
%      NYQUISTSIM, by itself, creates a new NYQUISTSIM or raises the existing
%      singleton*.
%
%      H = NYQUISTSIM returns the handle to a new NYQUISTSIM or the handle to
%      the existing singleton*.
%
%      NYQUISTSIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NYQUISTSIM.M with the given input arguments.
%
%      NYQUISTSIM('Property','Value',...) creates a new NYQUISTSIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before nyquistsim_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to nyquistsim_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help nyquistsim

% Last Modified by GUIDE v2.5 08-May-2013 00:46:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @nyquistsim_OpeningFcn, ...
                   'gui_OutputFcn',  @nyquistsim_OutputFcn, ...
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


% --- Executes just before nyquistsim is made visible.
function nyquistsim_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to nyquistsim (see VARARGIN)
handles.f = 1e6; %Plotting it at natively at 1000000.
handles.t = 0:(1/handles.f):1;

axes(handles.signal); 
axis off
axes(handles.sampled); 
axis off
set(handles.sigfreq,'String',0)
set(handles.sampfreq,'String',0)
set(handles.sampfreq,'visible','off')
set(handles.text2,'visible','off')
set(handles.equal,'visible','off')
set(handles.random,'visible','off')
set(handles.sin,'Value',1)
set(handles.cos,'Value',0)
set(handles.equal,'Value',1)
set(handles.random,'Value',0)

% Choose default command line output for nyquistsim
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes nyquistsim wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = nyquistsim_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles;



function sigfreq_Callback(hObject, eventdata, handles)
% hObject    handle to sigfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sigfreq as text
%        str2double(get(hObject,'String')) returns contents of sigfreq as a double
handles.signalf = get(handles.sigfreq,'String'); %What is the signal frequency?
set(handles.sampfreq,'visible','on') %Make everything visible
set(handles.text2,'visible','on')
set(handles.equal,'visible','on')
set(handles.random,'visible','on')


%Standard plotting routine
hold off

%Plot the signal
temp = str2num(handles.signalf); %Putting the frequency in temp
if get(handles.sin,'Value') == 1 %If sine, 
handles.y = sin(2.*pi.*temp.*handles.t); %plot sine
else
handles.y = cos(2.*pi.*temp.*handles.t); %else plose cosine
end
axes(handles.signal); %Switch to signal axes
h = plot(handles.t,handles.y); %Plot time points vs. signal curve 
ylim([-1.05 1.05]) %Ylims
set (h,'linewidth',2); %Set line width
axis off %Take the axis off

%Plot the red dots on the signal
hold on;
handles.sampf = get(handles.sampfreq,'String'); %What is the sampling frequency?
temp = round(str2num(handles.sampf)); %Converting it to a number I can use

if get(handles.equal,'Value') == 1
temp2 = linspace(1,1e6, temp);
handles.samplingpoints = temp2;
else
temp2 = randi(1e6,[round(str2num(handles.sampf)) 1]);    
handles.samplingpoints = temp2;
end

q = plot(handles.t(round(temp2)),handles.y(round(temp2)),'o');
set(q,'markerfacecolor','r')
set(q,'markeredgecolor','r')
axis off
hold off

%Plot the sampled waveform
axes(handles.sampled); 
hold off
temp3(:,1) = handles.t(round(temp2))';
temp3(:,2) = handles.y(round(temp2))';
temp4 = sortrows(temp3,1);
h = plot(temp4(:,1),temp4(:,2));
ylim([-1.05 1.05])
set (h,'linewidth',2);
xlim([0 1])
axis off
hold off

%Update everything
guidata(hObject, handles);

function sampfreq_Callback(hObject, eventdata, handles)
% hObject    handle to sampfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampfreq as text
%        str2double(get(hObject,'String')) returns contents of sampfreq as a double

%Standard plotting routine
hold off

%Plot the signal
temp = str2num(handles.signalf); %Putting the frequency in temp
if get(handles.sin,'Value') == 1 %If sine, 
handles.y = sin(2.*pi.*temp.*handles.t); %plot sine
else
handles.y = cos(2.*pi.*temp.*handles.t); %else plose cosine
end
axes(handles.signal); %Switch to signal axes
h = plot(handles.t,handles.y); %Plot time points vs. signal curve 
ylim([-1.05 1.05]) %Ylims
set (h,'linewidth',2); %Set line width
axis off %Take the axis off

%Plot the red dots on the signal
hold on;
handles.sampf = get(handles.sampfreq,'String'); %What is the sampling frequency?
temp = round(str2num(handles.sampf)); %Converting it to a number I can use
if get(handles.equal,'Value') == 1
temp2 = linspace(1,1e6, temp);
handles.samplingpoints = temp2;
else
temp2 = randi(1e6,[round(str2num(handles.sampf)) 1]);    
handles.samplingpoints = temp2;
end

q = plot(handles.t(round(temp2)),handles.y(round(temp2)),'o');
set(q,'markerfacecolor','r')
set(q,'markeredgecolor','r')
axis off
hold off

%Plot the sampled waveform
axes(handles.sampled); 
hold off
temp3(:,1) = handles.t(round(temp2))';
temp3(:,2) = handles.y(round(temp2))';
temp4 = sortrows(temp3,1);
h = plot(temp4(:,1),temp4(:,2));
ylim([-1.05 1.05])
set (h,'linewidth',2);
xlim([0 1])
axis off
hold off

%Update everything
guidata(hObject, handles);

% --- Executes on button press in sin.
function sin_Callback(hObject, eventdata, handles)
% hObject    handle to sin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of sin
set(handles.sin,'Value',1)
set(handles.cos,'Value',0)

%Standard plotting routine
hold off

%Plot the signal
temp = str2num(handles.signalf); %Putting the frequency in temp
if get(handles.sin,'Value') == 1 %If sine, 
handles.y = sin(2.*pi.*temp.*handles.t); %plot sine
else
handles.y = cos(2.*pi.*temp.*handles.t); %else plose cosine
end
axes(handles.signal); %Switch to signal axes
h = plot(handles.t,handles.y); %Plot time points vs. signal curve 
ylim([-1.05 1.05]) %Ylims
set (h,'linewidth',2); %Set line width
axis off %Take the axis off

%Plot the red dots on the signal
hold on;
handles.sampf = get(handles.sampfreq,'String'); %What is the sampling frequency?
temp = round(str2num(handles.sampf)); %Converting it to a number I can use
if get(handles.equal,'Value') == 1
temp2 = linspace(1,1e6, temp);
handles.samplingpoints = temp2;
else
temp2 = randi(1e6,[round(str2num(handles.sampf)) 1]);    
handles.samplingpoints = temp2;
end

q = plot(handles.t(round(temp2)),handles.y(round(temp2)),'o');
set(q,'markerfacecolor','r')
set(q,'markeredgecolor','r')
axis off
hold off

%Plot the sampled waveform
axes(handles.sampled); 
hold off
temp3(:,1) = handles.t(round(temp2))';
temp3(:,2) = handles.y(round(temp2))';
temp4 = sortrows(temp3,1);
h = plot(temp4(:,1),temp4(:,2));
ylim([-1.05 1.05])
set (h,'linewidth',2);
xlim([0 1])
axis off
hold off

%Update everything
guidata(hObject, handles);


% --- Executes on button press in cos.
function cos_Callback(hObject, eventdata, handles)
% hObject    handle to cos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cos
set(handles.sin,'Value',0)
set(handles.cos,'Value',1)

%Standard plotting routine
hold off

%Plot the signal
temp = str2num(handles.signalf); %Putting the frequency in temp
if get(handles.sin,'Value') == 1 %If sine, 
handles.y = sin(2.*pi.*temp.*handles.t); %plot sine
else
handles.y = cos(2.*pi.*temp.*handles.t); %else plose cosine
end
axes(handles.signal); %Switch to signal axes
h = plot(handles.t,handles.y); %Plot time points vs. signal curve 
ylim([-1.05 1.05]) %Ylims
set (h,'linewidth',2); %Set line width
axis off %Take the axis off

%Plot the red dots on the signal
hold on;
handles.sampf = get(handles.sampfreq,'String'); %What is the sampling frequency?
temp = round(str2num(handles.sampf)); %Converting it to a number I can use
if get(handles.equal,'Value') == 1
temp2 = linspace(1,1e6, temp);
handles.samplingpoints = temp2;
else
temp2 = randi(1e6,[round(str2num(handles.sampf)) 1]);    
handles.samplingpoints = temp2;
end

q = plot(handles.t(round(temp2)),handles.y(round(temp2)),'o');
set(q,'markerfacecolor','r')
set(q,'markeredgecolor','r')
axis off
hold off

%Plot the sampled waveform
axes(handles.sampled); 
hold off
temp3(:,1) = handles.t(round(temp2))';
temp3(:,2) = handles.y(round(temp2))';
temp4 = sortrows(temp3,1);
h = plot(temp4(:,1),temp4(:,2));
ylim([-1.05 1.05])
set (h,'linewidth',2);
xlim([0 1])
axis off
hold off

%Update everything
guidata(hObject, handles);

% --- Executes on button press in equal.
function equal_Callback(hObject, eventdata, handles)
% hObject    handle to equal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of equal
set(handles.equal,'Value',1)
set(handles.random,'Value',0)

%Standard plotting routine
hold off

%Plot the signal
temp = str2num(handles.signalf); %Putting the frequency in temp
if get(handles.sin,'Value') == 1 %If sine, 
handles.y = sin(2.*pi.*temp.*handles.t); %plot sine
else
handles.y = cos(2.*pi.*temp.*handles.t); %else plose cosine
end
axes(handles.signal); %Switch to signal axes
h = plot(handles.t,handles.y); %Plot time points vs. signal curve 
ylim([-1.05 1.05]) %Ylims
set (h,'linewidth',2); %Set line width
axis off %Take the axis off

%Plot the red dots on the signal
hold on;
handles.sampf = get(handles.sampfreq,'String'); %What is the sampling frequency?
temp = round(str2num(handles.sampf)); %Converting it to a number I can use
if get(handles.equal,'Value') == 1
temp2 = linspace(1,1e6, temp);
handles.samplingpoints = temp2;
else
temp2 = randi(1e6,[round(str2num(handles.sampf)) 1]);    
handles.samplingpoints = temp2;
end

q = plot(handles.t(round(temp2)),handles.y(round(temp2)),'o');
set(q,'markerfacecolor','r')
set(q,'markeredgecolor','r')
axis off
hold off

%Plot the sampled waveform
axes(handles.sampled); 
hold off
temp3(:,1) = handles.t(round(temp2))';
temp3(:,2) = handles.y(round(temp2))';
temp4 = sortrows(temp3,1);
h = plot(temp4(:,1),temp4(:,2));
ylim([-1.05 1.05])
set (h,'linewidth',2);
xlim([0 1])
axis off
hold off

%Update everything
guidata(hObject, handles);

% --- Executes on button press in random.
function random_Callback(hObject, eventdata, handles)
% hObject    handle to random (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of random
set(handles.equal,'Value',0)
set(handles.random,'Value',1)

%Standard plotting routine
hold off

%Plot the signal
temp = str2num(handles.signalf); %Putting the frequency in temp
if get(handles.sin,'Value') == 1 %If sine, 
handles.y = sin(2.*pi.*temp.*handles.t); %plot sine
else
handles.y = cos(2.*pi.*temp.*handles.t); %else plose cosine
end
axes(handles.signal); %Switch to signal axes
h = plot(handles.t,handles.y); %Plot time points vs. signal curve 
ylim([-1.05 1.05]) %Ylims
set (h,'linewidth',2); %Set line width
axis off %Take the axis off

%Plot the red dots on the signal
hold on;
handles.sampf = get(handles.sampfreq,'String'); %What is the sampling frequency?
temp = round(str2num(handles.sampf)); %Converting it to a number I can use
if get(handles.equal,'Value') == 1
temp2 = linspace(1,1e6, temp);
handles.samplingpoints = temp2;
else
temp2 = randi(1e6,[round(str2num(handles.sampf)) 1]);    
handles.samplingpoints = temp2;
end

q = plot(handles.t(round(temp2)),handles.y(round(temp2)),'o');
set(q,'markerfacecolor','r')
set(q,'markeredgecolor','r')
axis off
hold off

%Plot the sampled waveform
axes(handles.sampled); 
hold off
temp3(:,1) = handles.t(round(temp2))';
temp3(:,2) = handles.y(round(temp2))';
temp4 = sortrows(temp3,1);
h = plot(temp4(:,1),temp4(:,2));
ylim([-1.05 1.05])
set (h,'linewidth',2);
xlim([0 1])
axis off
hold off

%Update everything
guidata(hObject, handles);


%Put irrelevant shit below this line
% --- Executes during object creation, after setting all properties.
function sampfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function sigfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sigfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%Makes it immediately obvious why less than 1:2 is no good. 
%Makes it immediately obvious why cosine goes with odd, sine with even
%If it does match, it becomes 

%Make random plotting work
%Make EXE
%Make JAVA
