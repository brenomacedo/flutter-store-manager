import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:loja/blocs/user_bloc.dart';
import 'package:loja/widgets/user_tile.dart';

class UsersTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final UserBloc _userBloc = BlocProvider.getBloc<UserBloc>();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Pesquisar',
              hintStyle: TextStyle(
                color: Colors.white
              ),
              icon: Icon(Icons.search, color: Colors.white),
              border: InputBorder.none
            ),
            onChanged: _userBloc.onChangedSearch,
          ),
        ),
        Expanded(
          child: StreamBuilder<List>(
            builder: (context, snapshot) {
              if(!snapshot.hasData)
                return Center(child:
                  CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.pinkAccent)));
              if(snapshot.data.length == 0)
                return Center(child: Text('Nenhum usuário encontrado!', style: TextStyle(color: Colors.pinkAccent)));
              return ListView.separated(
                itemBuilder: (context, index) {
                  return UserTile(user: snapshot.data[index]);
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: snapshot.data.length
              );
            },
            stream: _userBloc.outUsers,
          )
        )
      ],
    );
  }
}