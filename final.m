function varargout = final(varargin)
% FINAL MATLAB code for final.fig
%      FINAL, by itself, creates a new FINAL or raises the existing
%      singleton*.
%
%      H = FINAL returns the handle to a new FINAL or the handle to
%      the existing singleton*.
%
%      FINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINAL.M with the given input arguments.
%
%      FINAL('Property','Value',...) creates a new FINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before final_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to final_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help final

% Last Modified by GUIDE v2.5 22-Nov-2017 23:00:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @final_OpeningFcn, ...
                   'gui_OutputFcn',  @final_OutputFcn, ...
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


% --- Executes just before final is made visible.
function final_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to final (see VARARGIN)

% Choose default command line output for final
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes final wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = final_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image
axes(handles.axes1);
%browse image
[imagename pathname]=uigetfile({'*.jpg';'*.tif';'*.png'},'find new pic');
image = imread(strcat(pathname,imagename));
set(handles.axes1,'Visible','On');
%importing the image
imshow(image);
set(handles.sigma,'Visible','on');
set(handles.kernal,'Visible','on');
set(handles.edit1,'Visible','on');
set(handles.edit2,'Visible','on');
set(handles.plus,'Visible','on');
set(handles.filter,'Visible','on');



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global sigma
%enter sigma value
sigma=get(handles.edit1,'string');


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
%enter kernal value
global kernal
kernal= get(handles.edit2,'string');


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in upload.
function upload_Callback(hObject, eventdata, handles)
% hObject    handle to upload (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image
global kernal
global sigma
global a
global kernal1
axes(handles.axes2);
sigma=str2double(sigma);
kernal=str2double(kernal);
%evaluating the kernal axis
a=(kernal-1)/2;
%evaluating kernal
e=1;
f=1;
for i=-a:a
    for j=-a:a
        b= ((i^2)+(j^2))/(sigma^2);
        c= exp(-0.5*b);
        kernal_value= -((1/(2*pi*(sigma^4)))*(2-b)*c);
        kernal1(e,f)=kernal_value;
        f=f+1;
    end
    e=e+1;
    f=1;
end
%making sum of all the component of kernal to zero
kernal1=kernal1-( sum(kernal1(:))/(kernal^2));
%converting rgb to gray
if size(image,3)==3
    rc=image(:,:,1);
    gc=image(:,:,2);
    bc=image(:,:,3);
       I = 0.2989 * rc + 0.5870 * gc + 0.1140 * bc;
else
   I=image;
end
%convution
I=double(I);
%padding the matrix
l=padarray(I,[a,a]);
output=zeros([size(l,1) size(l,2)]);
[m,n]=size(l);
for i=1:(m-kernal)
    for j=1:(n-kernal)
        
        temp=l(i:(i+kernal-1),j:(j+kernal-1)).*kernal1;
        output(i,j)=sum(temp(:));
        
    end
end
set(handles.axes2,'Visible','on');
imshow(output);
set(handles.save,'Visible','on');
set(handles.reset,'Visible','on');

        


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4



% --- Executes on button press in filter.
function filter_Callback(hObject, eventdata, handles)
% hObject    handle to filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%calculating kernal and 3d plotting
global sigma
global kernal
sigma=str2double(sigma);
kernal=str2double(kernal);
a=(kernal-1)/2;
kernal1=zeros(kernal);
e=1;
f=1;
for i=-a:a
    for j=-a:a
        b= ((i^2)+(j^2))/(sigma^2);
        c= exp(-0.5*b);
        kernal_value= -((1/(2*pi*(sigma^4)))*(2-b)*c);
        kernal1(e,f)=kernal_value;
        f=f+1;
    end
    e=e+1;
    f=1;
end
kernal1=kernal1-( sum(kernal1(:))/(kernal^2));

axes(handles.axes4);
[x,y]=meshgrid(-a:a,-a:a);
set(handles.axes4,'Visible','on');
surf(x,y,kernal1)
set(handles.equal,'Visible','on');
set(handles.upload,'Visible','on');


% --- Executes on button press in save.
function save_Callback(hObject, eventdata, handles)
% hObject    handle to save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%saving the image
axes(handles.axes2);
imsave();



% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%reseting all the value
axes(handles.axes1);
cla reset;
axes(handles.axes2);
cla reset;
axes(handles.axes4);
cla reset;
set(handles.axes1,'Visible','off');
set(handles.sigma,'Visible','off');
set(handles.kernal,'Visible','off');
set(handles.axes4,'Visible','off');
set(handles.filter,'Visible','off');
set(handles.axes2,'Visible','off');
set(handles.plus,'Visible','off');
set(handles.equal,'Visible','off');
set(handles.upload,'Visible','off');
set(handles.save,'Visible','off');
set(handles.reset,'Visible','off');
set(handles.edit1,'Visible','off');
set(handles.edit2,'Visible','off');
