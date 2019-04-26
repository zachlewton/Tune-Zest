from flask import Flask, redirect, render_template, request, url_for, flash, send_file
from flask_sqlalchemy import SQLAlchemy
##from wtforms import Form, StringField, TextAreaField, PasswordField, validators
from flask_migrate import Migrate
from flask_login import login_user, LoginManager, UserMixin, logout_user, login_required, current_user
from werkzeug.security import check_password_hash, generate_password_hash
from datetime import datetime
from io import BytesIO

import os

##from passwordlib.hash import sha256_crypt

APP_ROOT = os.path.dirname(os.path.abspath(__file__))
app = Flask(__name__)
app.config["DEBUG"] = True

SQLALCHEMY_DATABASE_URI = "mysql+mysqlconnector://{username}:{password}@{hostname}/{databasename}".format(
    username="zestylemon",
    password="icedog26",
    hostname="zestylemon.mysql.pythonanywhere-services.com",
    databasename="zestylemon$comments",
)
app.config["SQLALCHEMY_DATABASE_URI"] = SQLALCHEMY_DATABASE_URI
app.config["SQLALCHEMY_POOL_RECYCLE"] = 299
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False

db = SQLAlchemy(app)
migrate = Migrate(app, db)

app.secret_key = "ahfkdiepslghnbqgchpq"
login_manager = LoginManager()
login_manager.init_app(app)



class Fav_track(UserMixin, db.Model):
    __tablename__ = "fav_tracks"
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    fk_song_id = db.Column(db.Integer)
    fk_user_id = db.Column(db.Integer)


class Song_upload(UserMixin, db.Model):
    __tablename__ = "songs"
    song_id = db.Column(db.Integer, primary_key=True)
    song_name = db.Column(db.String(128))
    mp3_file = db.Column(db.String(128))
    album_art_file = db.Column(db.String(128))
    fk_user_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    artist_post = db.relationship('User', foreign_keys=fk_user_id)



class User(UserMixin, db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(128))
    password_hash = db.Column(db.String(128))
    artist_name = db.Column(db.String(128))
    location = db.Column(db.String(128))
    genre = db.Column(db.String(128))
    def check_password(self, password):
        return check_password_hash(self.password_hash, password)


    def get_id(self):
        return self.username



@login_manager.user_loader
def load_user(user_id):
    return User.query.filter_by(username=user_id).first()

class Comment(db.Model):

    __tablename__ = "comments"

    id = db.Column(db.Integer, primary_key=True)
    content = db.Column(db.String(4096))
    posted = db.Column(db.DateTime, default=datetime.now)
    commenter_id = db.Column(db.Integer, db.ForeignKey('users.id'), nullable=True)
    commenter = db.relationship('User', foreign_keys=commenter_id)
    song_id = db.Column(db.Integer)


@app.route("/", methods=["GET", "POST"])
def index():
    if current_user.is_authenticated:
        if request.method == "GET":
            return render_template("homepagedraft.html", comments=Comment.query.all())
    if not current_user.is_authenticated:
        return redirect(url_for('login'))

    comment = Comment(content=request.form["contents"], commenter=current_user)
    db.session.add(comment)
    db.session.commit()
    return redirect(url_for('index'))

@app.route("/login/", methods=["GET", "POST"])
def login():
    if request.method == "GET":
        return render_template("login_page.html", error=False)

    user = load_user(request.form["username"])
    if user is None:
        return render_template("login_page.html", error=True)

    if not user.check_password(request.form["password"]):
        return render_template("login_page.html", error=True)

    login_user(user)
    return redirect(url_for('homepagedraft'))

@app.route("/logout/")
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))


@app.route('/homepagedraft/', methods=["GET", "POST"])
def homepagedraft():
    if request.method == "GET":
        return render_template("homepagedraft.html")



@app.route('/register/', methods=['GET', 'POST'])
def register():
    if request.method == "GET":
        return render_template("register.html")



    if request.method == "POST":
        if request.form["password"]==request.form["check_password"]:
            new_user = User(username=request.form["username"], password_hash= generate_password_hash(request.form["password"]), artist_name=request.form["artist_name"], location=request.form["location"], genre=request.form["genre"])
            db.session.add(new_user)
            db.session.commit()
            current_user.is_authenticated
            return redirect(url_for('homepagedraft'))
        else:
            flash('Passwords did not match', 'error')
            return redirect(url_for('register'))



@app.route('/upload/', methods=['GET', 'POST'])
def upload():

    if current_user.is_authenticated:
        if request.method == "GET":

            return render_template("upload_page.html")

        if request.method == "POST":
            mp3_file_upload=request.files['mp3_file']
            art_file_upload=request.files['album_art']

            ####album art save to folder#####
            target_art = os.path.join(APP_ROOT, 'album_art_folder/')
            art_filename = art_file_upload.filename
            destination_art = "/".join([target_art, art_filename])
            art_file_upload.save(destination_art)

            ###mp3 file save to folder####
            target_song = os.path.join(APP_ROOT, 'song_file_folder/')
            song_filename = mp3_file_upload.filename
            destination_song = "/".join([target_song, song_filename])
            mp3_file_upload.save(destination_song)


            #myUser = User.query.all()
            new_track = Song_upload(song_name=request.form["song_name"], mp3_file=mp3_file_upload.filename, album_art_file=art_file_upload.filename, artist_post=current_user)
            db.session.add(new_track)
            db.session.commit()
            return redirect(url_for('index'))
    if not current_user.is_authenticated:
        return redirect(url_for('login'))


@app.route('/search/', methods=['GET', 'POST'])
def search():
    if request.method=="GET":
        return render_template("search.html")
    if request.method == "POST":
        search=request.form["search_text"]
        #return redirect(url_for('search', search=search))
        search_result=User.query.filter_by(artist_name = search)
        return render_template("search.html", search_result=search_result)
@app.route('/profile/', methods=['GET', 'POST'])
def profile():

    if request.method == "GET":

        user = current_user
        songs = Song_upload.query.filter_by(fk_user_id=user.id)
        fav_songs = Fav_track.query.filter_by(fk_user_id=user.id)

        return render_template("profile.html", user=user, songs=songs, fav_songs=fav_songs)

    if request.method == "POST":
        search=request.form["search_text"]
        #return redirect(url_for('search', search=search))
        search_result=User.query.filter_by(artist_name = search)




        return render_template("search.html", search_result=search_result)


@app.route('/music/', methods=['GET', 'POST'])
@app.route('/music/<artist_id>', methods=['GET', 'POST'])
def music(artist_id=1):
        user = User.query.filter_by(id=artist_id).first()
        songs = Song_upload.query.filter_by(fk_user_id=artist_id)

        if request.method == "GET":



            return render_template("music.html", user=user, songs=songs, comments=Comment.query.all())



        if request.method == "POST":


            comment = Comment(content=request.form["contents"], commenter=current_user, song_id=request.form["song_id"])
            db.session.add(comment)
            db.session.commit()
            return redirect(url_for('index'))

























