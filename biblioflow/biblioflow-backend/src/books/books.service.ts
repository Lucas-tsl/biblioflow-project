import { Injectable, NotFoundException } from '@nestjs/common';
import { CreateBookDto } from './dto/create-book.dto';
import { UpdateBookDto } from './dto/update-book.dto';
import { Book } from './entities/book.entity';
import { randomUUID } from 'crypto';

@Injectable()
export class BooksService {
  private books: Book[] = [];

  create(dto: CreateBookDto): Book {
    const book: Book = { id: randomUUID(), ...dto };
    this.books.push(book);
    return book;
  }

  findAll(): Book[] {
    return this.books;
  }

  findOne(id: string): Book {
    const b = this.books.find((x) => x.id === id);
    if (!b) throw new NotFoundException('Book not found');
    return b;
  }

  update(id: string, dto: UpdateBookDto): Book {
    const idx = this.books.findIndex((x) => x.id === id);
    if (idx === -1) throw new NotFoundException('Book not found');
    const updated = { ...this.books[idx], ...dto };
    this.books[idx] = updated;
    return updated;
  }

  remove(id: string): void {
    const before = this.books.length;
    this.books = this.books.filter((x) => x.id !== id);
    if (this.books.length === before) {
      throw new NotFoundException('Book not found');
    }
  }
}
