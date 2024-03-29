import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

void main() {
  runApp(
    DevicePreview(
      builder: (context) => MyApp(), // Wrap your app
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder, // Add the builder here
      title: 'MyApp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RegisterPage(),
    );
  }
}


class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Chave global para o formulário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form( // Envolve os TextFields com um widget Form
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira seu email.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha *',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira sua senha.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) { // Valida o formulário antes de prosseguir
                    final prefs = await SharedPreferences.getInstance();
                    String storedEmail = prefs.getString('email') ?? '';
                    String storedPassword = prefs.getString('password') ?? '';

                    String enteredEmail = emailController.text;
                    String enteredPassword = passwordController.text;

                    if (enteredEmail == storedEmail && enteredPassword == storedPassword) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Erro de Login'),
                            content: Text('Email ou senha incorretos. Por favor, tente novamente.'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                },
                child: Text('Entrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class RegisterPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Chave global para o formulário

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form( // Envolve os TextFields com um widget Form
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nome *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira seu nome.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira seu email.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha *',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira sua senha.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) { // Valida o formulário antes de prosseguir
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('name', nameController.text);
                    prefs.setString('email', emailController.text);
                    prefs.setString('password', passwordController.text);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  }
                },
                child: Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Aplicativo de lista de compras',
              style: TextStyle(fontSize: 20),
            ),
            Text('Alexandre Borghi, Código: 835019'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ComprasPage()),
                );
              },
              child: Text('Carrinho'),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemLista {
  String nome;
  int quantidade;
  bool selecionado;

  ItemLista({required this.nome, required this.quantidade, this.selecionado=false});
}

class ListaDeCompras {
  String nome;
  List<ItemLista> itens;

  ListaDeCompras({required this.nome, required this.itens});
}

class ComprasPage extends StatefulWidget {
  @override
  _ComprasPageState createState() => _ComprasPageState();
}

class _ComprasPageState extends State<ComprasPage> {
  final TextEditingController _novoItemNomeController = TextEditingController();
  final TextEditingController _novoItemQuantidadeController = TextEditingController();
  String _novoNomeLista = '';
  String _pesquisa = '';
  List<ListaDeCompras> _listasDeCompras = [];
  ListaDeCompras? _listaSelecionada;
  List<ItemLista> _itensFiltrados = [];

  List<ItemLista> pesquisarItens(String pesquisa) {
  if (pesquisa.isEmpty) {
    return _listaSelecionada!.itens;
  } else {
    return _listaSelecionada!.itens.where((item) => item.nome.toLowerCase().contains(pesquisa.toLowerCase())).toList();
  }
}
  void editarItem(ItemLista item) {
  TextEditingController quantidadeController = TextEditingController(text: item.quantidade.toString());
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Editar Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: item.nome),
              decoration: InputDecoration(labelText: 'Nome'),
              onChanged: (value) {
                item.nome = value;
              },
            ),
            TextField(
              controller: quantidadeController,
              decoration: InputDecoration(labelText: 'Quantidade'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                item.quantidade = int.tryParse(quantidadeController.text) ?? item.quantidade;
              },
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                // Atualizar os dados do item
              });
              Navigator.of(context).pop();
            },
            child: Text('Salvar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
        ],
      );
    },
  );
}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Compras'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Criar Nova Lista:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: TextEditingController(text: _novoNomeLista),
              decoration: InputDecoration(
                labelText: 'Nome da Lista',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _novoNomeLista = value;
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _listasDeCompras.add(ListaDeCompras(nome: _novoNomeLista, itens: []));
                  _novoNomeLista = '';
                });
              },
              child: Text('Criar Lista'),
            ),
            SizedBox(height: 20),
            Text(
              'Editar Lista Selecionada:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DropdownButton<ListaDeCompras>(
              value: _listaSelecionada,
              onChanged: (value) {
                setState(() {
                  _listaSelecionada = value;
                });
              },
              items: _listasDeCompras
                  .map<DropdownMenuItem<ListaDeCompras>>((lista) => DropdownMenuItem(
                        value: lista,
                        child: Text(lista.nome),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            if (_listaSelecionada != null) ...[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Novo Nome',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _listaSelecionada!.nome = value;
                  });
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _listaSelecionada = null;
                  });
                },
                child: Text('Cancelar Edição'),
              ),
              TextField(
              decoration: InputDecoration(
                labelText: 'Pesquisar Itens',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _pesquisa = value;
                });
              },
            ),
            ListView.builder(
            shrinkWrap: true,
            itemCount: pesquisarItens(_pesquisa).length,
            itemBuilder: (context, index) {
              ItemLista item = pesquisarItens(_pesquisa)[index];
              return ListTile(
                title: Text(item.nome),
                subtitle: Text('Quantidade: ${item.quantidade}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _listaSelecionada!.itens.remove(item);
                    });
                  },
                ),
              );
            },
          ),
              SizedBox(height: 20),
              Text(
                'Itens da Lista Selecionada:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
             /* for (var item in _listaSelecionada!.itens) ...[
                ListTile(
                  title: Text(item.nome),
                  subtitle: Text('Quantidade: ${item.quantidade}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _listaSelecionada!.itens.remove(item);
                      });
                    },
                  ),
                ),
              ],*/
              for (var item in _listaSelecionada!.itens) ...[
              ListTile(
                title: Text(item.nome),
                subtitle: Text('Quantidade: ${item.quantidade}'),
                leading: Checkbox(
                  value: item.selecionado,
                  onChanged: (value) {
                    setState(() {
                      item.selecionado = value!;
                    });
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => editarItem(item), // Chama o método para editar o item
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _listaSelecionada!.itens.remove(item);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
              SizedBox(height: 20),
              Text(
                'Adicionar Item à Lista:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _novoItemNomeController,
                decoration: InputDecoration(
                  labelText: 'Nome do Item',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _novoItemQuantidadeController,
                decoration: InputDecoration(
                  labelText: 'Quantidade',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _listaSelecionada!.itens.add(ItemLista(
                      nome: _novoItemNomeController.text,
                      quantidade: int.tryParse(_novoItemQuantidadeController.text) ?? 1,
                    ));
                    _novoItemNomeController.clear();
                    _novoItemQuantidadeController.clear();
                  });
                },
                child: Text('Adicionar Item'),
              ),
            ],
          ],
        ),
      ),
    );
    
  }
  
}